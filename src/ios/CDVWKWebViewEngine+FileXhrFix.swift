import ObjectiveC

extension CDVWKWebViewEngine {
    class func load() {
        let selector = NSSelectorFromString("createConfigurationFromSettings:")
        let originalMethod = class_getInstanceMethod(CDVWKWebViewEngine.self, selector)
        let originalImp = method_getImplementation(originalMethod)
        typealias send_type = ((Any?, Selector, [AnyHashable : Any]?) -> WKWebViewConfiguration)?
        let originalImpSend = originalImp as? send_type

        let newImp = imp_implementationWithBlock({ _self, settings in
                // Get the original configuration
                var configuration = originalImpSend?(_self, selector, settings)

                // allow access to file api
                // TODO: import SwiftTryCatch from https://github.com/eggheadgames/SwiftTryCatch
                SwiftTryCatch.try({
                    configuration.preferences.setValue(NSNumber(value: true), forKey: "allowFileAccessFromFileURLs")
                }, catch: { exception in
                }, finallyBlock: {
                })

                // TODO: import SwiftTryCatch from https://github.com/eggheadgames/SwiftTryCatch
                SwiftTryCatch.try({
                    configuration.setValue(NSNumber(value: true), forKey: "allowUniversalAccessFromFileURLs")
                }, catch: { exception in
                }, finallyBlock: {
                })

                return configuration
            })

        method_setImplementation(originalMethod, newImp)
    }
}
