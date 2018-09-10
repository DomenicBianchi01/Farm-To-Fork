# Farm To Fork

This project is still in development and there may be bugs or incomplete features in the app. The backend and website are still in development but not yet public.

If you want to try out the app in its current state, you can create an account. When the app prompts you to select your country, only Canada is currently supported. Province and City currently have no effect since the app will always use the City of Guelph.

NOTE: This project is being built using Xcode 10 Beta and Swift 4.2. When you try to compile, you will get an error from DeviceKit regarding `return UIAccessibilityIsGuidedAccessEnabled()`. Replace this line with `return UIAccessibility.isGuidedAccessEnabled` and the project should compile.
