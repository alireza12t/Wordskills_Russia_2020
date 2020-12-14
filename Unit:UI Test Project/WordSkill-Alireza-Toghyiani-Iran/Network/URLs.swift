

import Foundation
import Alamofire


let BASEURL = "http://cinema.areas.su"
let VideoBaseURL = "http://cinema.areas.su/up/video/"
let ImageBaseURL = "http://cinema.areas.su/up/images/"

enum URLs: APIConfiguration {
    
    case register(email: String, password: String, firstName: String, lastName: String)
    case login(email: String, password: String)
    case mainCover
    case movieList(filter: String)
    case lastWatch(filter: String)
    case movieInfo(id: String)
    case episodes(movieID: String)
    
    case getUserData
    case updateAvatar
    
    case sendMessage(chatID: String, message: String)
    case getMessage(chatID: String)
    case chatList(movieID: String)

    
    
    var METHOD: HTTPMethod {
        switch self {
        case .register, .login, .sendMessage:
            return .post
        default:
            return .get
        }
    }
    
    var FULL_PATH_URL: String {
        switch self {
        case .register:
            return BASEURL + "/auth/register"
        case .login:
            return BASEURL + "/auth/login"
        case .mainCover:
            return BASEURL + "/movies/cover"
        case .movieList:
            return BASEURL + "/movies"
        case .lastWatch:
            return BASEURL + "/usermovies"
        case .movieInfo(id: let id):
            return BASEURL + "/movies/\(id)"
        case .episodes(movieID: let id):
            return BASEURL + "/movies/\(id)/episodes"
        case .getUserData:
            return BASEURL + "/user"
        case .updateAvatar:
            return BASEURL + "/user/avatar"
        case .sendMessage(chatID: let chatID, message: _):
            return BASEURL + "/chats/\(chatID)/messages"
        case .getMessage(chatID: let chatID):
            return BASEURL + "/chats/\(chatID)/messages"
        case .chatList(movieID: let movieID):
            return BASEURL + "/chats/\(movieID)"
        }
        
    }
    
    var PARAMETERS: Parameters?
    {
        switch self {
        case .movieList(filter: let filter):
            return [
                "filter" : filter
            ]
            
        case .lastWatch(filter: let filter):
            return [
                "filter" : filter
            ]
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var urlRequest = URLRequest(url: try FULL_PATH_URL.asURL())
        var urlComponents = URLComponents(string: "\(urlRequest)")
        
        if let parameters = PARAMETERS {
            var param = [URLQueryItem]()
            parameters.keys.forEach({ (key) in param.append(URLQueryItem(name: key, value: "\(parameters[key]!)")) })
            urlComponents?.queryItems = param.reversed()
            
        }
        
        urlRequest = URLRequest(url: (urlComponents?.url)!)
        
        switch self {
        case .register(email: let email, password: let password, firstName: let firstName, lastName: let lastName):
            let json: [String: Any] = [
                "email": email,
                "password": password,
                "firstName": firstName,
                "lastName": lastName
            ]
            Log.i("HTTP Body FOR walletIncreaseIPG =>  \(json)")
            
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: json)
            } catch let error {
                Log.e(error.localizedDescription)
            }
        case .login(email: let email, password: let password):
            let json: [String: Any] = [
                "email": email,
                "password": password
            ]
            Log.i("HTTP Body FOR walletIncreaseIPG =>  \(json)")
            
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: json)
            } catch let error {
                Log.e(error.localizedDescription)
            }
        case .sendMessage(chatID: _, message: let message):
            let json: [String: Any] = [
                "text": message
            ]
            Log.i("HTTP Body FOR walletIncreaseIPG =>  \(json)")
            
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: json)
            } catch let error {
                Log.e(error.localizedDescription)
            }
        default:
            break
        }
        
        switch self {
        case .lastWatch, .updateAvatar, .sendMessage, .chatList, .getMessage, .getUserData:
             urlRequest.setValue(StoringData.token, forHTTPHeaderField: NetworkConstant.HTTPHeaderField.authorization)
        default:
            break
        }
        
        
        urlRequest.setValue(NetworkConstant.ContentType.json, forHTTPHeaderField: NetworkConstant.HTTPHeaderField.contentType)
        
        urlRequest.httpMethod = METHOD.rawValue
        
        
        Log.i("API Request => \(urlRequest)")
        Log.i("API Request All Headers => \(urlRequest.allHTTPHeaderFields!)")
        
        return urlRequest
        
    }
}
