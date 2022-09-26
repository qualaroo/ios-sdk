//
//  ProgressCalculator.swift
//  Qualaroo
//
//  Created by Marcin Robaczyński on 13/07/2018.
//  Copyright © 2018 Mihály Papp. All rights reserved.
//

import UIKit

class ProgressCalculator {

    private let surveyWireframe: SurveyWireframeProtocol
    private var nodes: Set<GraphNode> = []
    private var graph: Graph? = nil
    
    init(_ wireframe: SurveyWireframeProtocol) {
        self.surveyWireframe = wireframe
        initGraphNodes()
    }
    
    public func setCurrentStep(_ nodeId: Int64) {
        if let node = nodeById(nodeId) {
            graph = Graph(node)
        }
    }
    
    public func getStepsLeft() -> Int {
        return graph?.longestPathFromRoot() ?? 0
    }
    
    private func initGraphNodes() {
        if let rootNode = surveyWireframe.firstNode() {
            buildFromRootNode(rootNode)
        }
    }
    
    private func node(_ question: Question) -> GraphNode {
        if let node = nodeById(question.nodeId()) {
            return node
        }
        var children = [GraphNode]()
        
        question.answerList.forEach {
            let response = QuestionResponse(
                id: question.nodeId(),
                alias: "",
                answerList: [AnswerResponse(id: $0.answerId, alias: "", text: "")]
            )
            if let answerNode = surveyWireframe.nextNode(for: question.nodeId(), response: NodeResponse.question(response)) {
                children.append(buildNode(answerNode))
            }
        }
        
        if let nextNodeId = question.nextId(), let nextNode = surveyWireframe.nextNode(for: nextNodeId, response: nil) {
            children.append(buildNode(nextNode))
        }
        
        let (_, result) = nodes.insert(GraphNode(question.nodeId(), children))
        return result
    }
    
    private func node(_ leadGen: LeadGenForm) -> GraphNode {
        if let node = nodeById(leadGen.nodeId()) {
            return node
        }
        var children = [GraphNode]()
        if let nextNode = surveyWireframe.nextNode(for: leadGen.nodeId(), response: nil) {
            children.append(buildNode(nextNode))
        }
        let (_, result) = nodes.insert(GraphNode(leadGen.nodeId(), children))
        return result
    }
    
    private func node(_ message: Message) -> GraphNode {
        if let node = nodeById(message.nodeId()) {
            return node
        }
        let (_, result) = nodes.insert(GraphNode(message.nodeId(), []))
        return result
    }
    
    @discardableResult private func buildFromRootNode(_ rootNode: Node) -> GraphNode {
        return buildNode(rootNode)
    }
    
    private func buildNode(_ fromNode: Node) -> GraphNode {
      if let question = fromNode as? Question {
        return node(question)
      }
      
      if let leadGen = fromNode as? LeadGenForm {
        return node(leadGen)
      }
      
      if let message = fromNode as? Message {
        return node(message)
      }
      
      return GraphNode(0, [])
    }
    
    private func nodeById(_ id: Int64) -> GraphNode? {
        return nodes.first(where: { $0.id == id })
    }

}

class Graph {
    let root: GraphNode
    
    init(_ root: GraphNode) {
        self.root = root
    }
    
    func longestPathFromRoot() -> Int {
        let nodes = topologicalSort(root)
        var distanceToNodes: [GraphNode: Int] = [:]
        nodes.forEach {
            distanceToNodes[$0] = 0
        }
        
        for node in nodes {
            for child in node.children {
                if (distanceToNodes[child]! < distanceToNodes[node]! + 1) {
                    distanceToNodes[child] = distanceToNodes[node]! + 1
                }
            }
        }
        
        return distanceToNodes.values.max() ?? 0
    }
    
    private func topologicalSort(_ root: GraphNode) -> [GraphNode] {
        var visited = Set<GraphNode>()
        var result: [GraphNode] = []
        topologicalSort(root, &visited, &result)
        result.reverse()
        return result
    }
    
    private func topologicalSort(_ node: GraphNode, _ visited: inout Set<GraphNode>, _ result: inout [GraphNode]) {
        if (visited.contains(node)) {
            return
        }
        
        for child in node.children {
            topologicalSort(child, &visited, &result)
        }

        visited.insert(node)
        result.append(node)
    }
}

class GraphNode : Hashable, Equatable {    
    static func == (lhs: GraphNode, rhs: GraphNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int64
    let children: [GraphNode]
    
    init(_ id: Int64, _ children: [GraphNode]) {
        self.id = id
        self.children = children
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
