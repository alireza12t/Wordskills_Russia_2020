import Foundation
import Alamofire
import RxSwift


struct EmptyResponse: Codable {
}

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}


class API {
    
    static let shared = API()
    
    
    func login(email: String, password: String) -> Observable<Login> {
        Log.i()
        return request(URLs.login(email: email, password: password))
    }
    
    func register(email: String, password: String, firstName: String, lastName: String) -> Observable<EmptyResponse> {
        Log.i()
        return request(URLs.register(email: email, password: password, firstName: firstName, lastName: lastName))
    }
    
    func mainCover() -> Observable<MainCover> {
        Log.i()
        return request(URLs.mainCover)
    }
    
    func movieList(filter: String) -> Observable<MovieList> {
        Log.i()
        return request(URLs.movieList(filter: filter))
    }
    
    func lastWatch(filter: String = "lastView") -> Observable<LastWatch> {
        return request(URLs.lastWatch(filter: filter))
    }
    
    func movieInfo(id: String) -> Observable<MovieInfo> {
        return request(URLs.movieInfo(id: id))
    }
    
    func episodes(movieID: String ) -> Observable<Episodes> {
        return request(URLs.episodes(movieID: movieID))
    }
    
    func userData() -> Observable<[User]> {
        return request(URLs.getUserData)
    }
    
    func sendMessage(chatID: String, message: String) -> Observable<Message> {
        return request(URLs.sendMessage(chatID: chatID, message: message))
    }
    
    func getMessages(chatID: String) -> Observable<[Message]> {
        return request(URLs.getMessage(chatID: chatID))
    }
    
    func chatList(movieID: String) -> Observable<[Chat]> {
        return request(URLs.chatList(movieID: movieID))
    }
    
    func uploadAvatar(image: UIImage)  -> Observable<User>  {
        
        let imageData = image.jpegData(compressionQuality: 0.50)
        print(image, imageData!)
        return Observable<User>.create { observer  in
        
            let data = image.pngData()!

            
            
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(data, withName: "file", fileName: "avatar.jpg", mimeType: "image/png")
//                multipartFormData.append(Data(StoringData.token.utf8), withName: "token", mimeType: "text/plain")
            }, with: URLs.updateAvatar)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        let array = data as! [Any]
                        let dict = array[0]
                        
                        do {
                            let value = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                            let user = try JSONDecoder().decode(User.self, from: value)
                            Log.i("SUCSESS => VALUE => \(String(describing: user))")
                            observer.onNext(user)
                            observer.onCompleted()
                        } catch(let error) {
                            Log.e("FAILURE => ERROR DESCRIPTION => \(String(describing: error.localizedDescription))")
                            observer.onError(error)
                            observer.onCompleted()
                        }

                    case .failure(let error):
                        Log.e("FAILURE => ERROR DESCRIPTION => \(String(describing: error.errorDescription))")
                        observer.onError(error)
                        observer.onCompleted()
                    }
                })
            
            return Disposables.create()
        }
    }
    
    func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        Log.i()
        
        return Observable<T>.create { observer  in
            NetworkManager.isReachable { _ in
                
                _ = AF.request(urlConvertible, interceptor: NetworkInterceptor()).validate().responseDecodable
                { (response: DataResponse<T,AFError>) in
                    Log.i("REQUEST => \(String(describing: response.request))")
                    Log.i("STATUS CODE => \(String(describing: response.response?.statusCode))")
                    let requestBody = String(data: ((response.request?.httpBody) ?? "".data(using: .utf8))!, encoding:.utf8)
                    Log.i("REQUEST BODY =>  \(String(describing: requestBody))")
                    
                    switch response.result {
                    case .success(let value):
                        Log.i("SUCSESS => VALUE => \(String(describing: value))")
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        switch error {
                        case .responseSerializationFailed(let reason):
                            if case .inputDataNilOrZeroLength = reason  {
                                observer.onNext(EmptyResponse() as! T)
                                observer.onCompleted()
                            }
                            
                            if response.error?.responseCode == 201 || response.error?.responseCode == 200 || response.response!.statusCode == 201{
                                
                                observer.onNext(EmptyResponse() as! T)
                                observer.onCompleted()
                            }
                            
                            print(reason)
                            observer.onError(NSError(domain: error.errorDescription ?? "Error", code: response.response!.statusCode, userInfo: nil))
                            observer.onCompleted()
                            
                        case .serverTrustEvaluationFailed:
                            print("Certificate Pinning Error")
                            observer.onError(NSError(domain: "Certificate Pinning Error", code: response.response!.statusCode, userInfo: nil))
                            observer.onCompleted()
                            
                        default:
                            Log.e("FAILURE => ERROR DESCRIPTION => \(String(describing: error.errorDescription))")
                            observer.onError(error)
                            observer.onCompleted()
                        }
                    }
                }
                
            }
            
            NetworkManager.isUnreachable { _ in
                DialogueHelper.showStatusBarErrorMessage(errorMessageStr: "لطفا اتصال خود به اینترنت را بررسی کنید.")
                observer.onError(NSError(domain: "No connection", code: 0, userInfo: nil))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

