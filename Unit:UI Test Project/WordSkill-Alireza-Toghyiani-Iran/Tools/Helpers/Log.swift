

import Foundation
/**
     This class sends logs to swifty beaver (a cross platofrom logging system)
*/
class Log {
    static var isActive: Bool = true
    /**
         This function prints out debug logs in console
         - parameter callingFunctionName: name of the function that is called
         - parameter callingClassName: name of the calss that holds the calling function.
         - parameter message: a custom message that needs to be printed in console.
         - parameter file : any type of file that is used to call the function or the function is processing
    */
    static func i(callingFunctionName: String = #function, callingClassName: String = #file,_ messsage: String = "", file: Any? = nil){
        if self.isActive{
                print("Log => \((callingClassName as NSString).lastPathComponent) - \(callingFunctionName)" + " => " + messsage)
        }
    }
    /**
         This function prints out error logs in console
         - parameter callingFunctionName: name of the function that is called
         - parameter callingClassName: name of the calss that holds the calling function.
         - parameter message: a custom message that needs to be printed in console.
         - parameter file : any type of file that is used to call the function or the function is processing
    */
    static func e(callingFunctionName: String = #function, callingClassName: String = #file,_ messsage: String = "", file: Any? = nil)  {
        if self.isActive{
                print("Error => \((callingClassName as NSString).lastPathComponent) - \(callingFunctionName)" + " => " + messsage)
        }
    }
   /**
        This function prints out warning logs in console
        - parameter callingFunctionName: name of the function that is called
        - parameter callingClassName: name of the calss that holds the calling function.
        - parameter message: a custom message that needs to be printed in console.
        - parameter file : any type of file that is used to call the function or the function is processing
   */
    static func w(callingFunctionName: String = #function, callingClassName: String = #file,_ messsage: String = "", file: Any? = nil)  {
        if self.isActive{
            print("Warning => \((callingClassName as NSString).lastPathComponent) - \(callingFunctionName)" + " => " + messsage)
        }
    }
}

