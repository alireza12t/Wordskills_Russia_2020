import Foundation

struct NetworkConstant {


    struct HTTPHeaderField {
        static let authorization = "Authorization"
        static let contentType = "Content-Type"
        static let clientId = "clientId"
        static let clientSecret = "clientSecret"
        static let scope = "scope"
    }
    
    
    struct APIParameterKey{
        
    }

    struct APIBodyKey{
        
    }

    struct APIBodyValue{
    }

    struct ContentType {
        static let json = "application/json"
        static let urlencoded = "application/x-www-form-urlencoded"
        static let textPlain = "text/plain"
        
        static let scope = "a b"
        static let clientSecret = "mymci"
        static let clientId = "9f740bf9-817a-4539-bb1d-43790fc93b75"
    }

}
