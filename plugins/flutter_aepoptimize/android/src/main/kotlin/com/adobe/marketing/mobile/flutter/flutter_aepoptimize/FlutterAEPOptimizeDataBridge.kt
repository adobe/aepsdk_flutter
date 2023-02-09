import com.adobe.marketing.mobile.optimize.DecisionScope

class FlutterAEPOptimizeDataBridge {
    companion object DataBridge {
        fun decisionScopeFromMap(map: Map<String, Any>): DecisionScope? {
            if (map.isEmpty()) {
                return null
            }

            val name = map["name"] as String?
            if (name != null) {
                return DecisionScope(name)
            }

            val activityId = map["activityId"] as String?
            val placementId = map["placementId"] as String?
            val itemCount = map["itemCount"] as Int?

            if (itemCount != null) {
                return DecisionScope(
                    activityId,
                    placementId,
                    itemCount
                )
            }

            return DecisionScope(activityId, placementId)
        }
    }
}