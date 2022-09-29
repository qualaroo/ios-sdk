import UIKit
import JavaScriptCore

class CustomPropertiesFilter {
  
  let propertiesRegex = try? NSRegularExpression(pattern: "([\\w_]+)(?=\\s*[=><!=])", options: [])
  
  let customProperties: CustomProperties
  
  init(customProperties: CustomProperties) {
    self.customProperties = customProperties
  }
  
  func check(rule: String?,
             surveyId: Int) -> Bool {
    guard let rule = rule, !rule.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      return true
    }
    let keywords = requiredVariables(rule)
    let missingProperties = customProperties.checkForMissing(withKeywords: keywords)
    if missingProperties.count > 0 {
      Qualaroo.log("""
        Not showing survey with id: \(surveyId).
        Missing custom properties: \(missingProperties.joined(separator: ", "))
        """)
      return false
    }
    let expression = replaceVariablesWithProperties(rule, properties: customProperties.dictionary)
    let jsValue = JSContext().evaluateScript("eval('\(expression)')")
    let shouldShow = jsValue?.toBool() ?? false
    if !shouldShow {
      Qualaroo.log("""
        Not showing survey with id: \(surveyId).
        Users custom properties don't match given predicate.
        """)
      return false
    }
    return true
  }

  private func requiredVariables(_ rule: String) -> [String] {
    guard let propertiesRegex = propertiesRegex else { return [] }
    return propertiesRegex.matches(in: rule, options: [], range: NSRange(location: 0, length: rule.count))
      .map { result -> String in
        let hrefRange = result.range(at: 1)
        let start = hrefRange.location
        let end = hrefRange.location + hrefRange.length
        return rule[start..<end]
      }.filter { !$0.isNumber }
  }
  
  private func replaceVariablesWithProperties(_ rule: String, properties: [String: String]) -> String {
    var filledRule = rule
    guard let propertiesRegex = propertiesRegex else { return rule }
    let matches = propertiesRegex.matches(in: rule, options: [], range: NSRange(location: 0, length: rule.count))
    for match in matches.reversed() {
      let variable = String(rule[rule.range(from: match.range(at: 1))])
      if variable.isNumber { continue }
      
      let range = filledRule.range(from: match.range)
      let value = parseValue(properties[variable])
      let replacement = propertiesRegex.replacementString(for: match, in: filledRule, offset: 0, template: value)
      filledRule.replaceSubrange(range, with: replacement)
    }
    return filledRule
  }
  
  private func parseValue(_ value: String?) -> String {
    guard let value = value else { return "" }
    if value.isNumber {
      return value
    }
    return "\"\(value)\""
  }
  


}

extension CustomPropertiesFilter: FilterProtocol {
  func shouldShow(survey: Survey) -> Bool {
    return check(rule: survey.requireMap.customRequirementsRule,
                 surveyId: survey.surveyId)
  }
}
