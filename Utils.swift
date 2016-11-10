
import Foundation

class Utils {
    
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
    class func doGet(url: String) {
        
        if url.isEmpty {
            return
        }
        
        let myUrl = NSURL(string: url);
        
        let request = NSMutableURLRequest(URL:myUrl!);
        
        request.HTTPMethod = "GET"
        
        // Excute HTTP Request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                //print("error=\(error)")
                return
            }
            
            // Print out response string
            //let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print("responseString = \(responseString)")
            
            
            // Convert server json response to NSDictionary
           /* do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    // Get value by key
                    let firstNameValue = convertedJsonIntoDict["userName"] as? String
                    print(firstNameValue!)
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            */
        }
        
        task.resume()
        
    }
    
}
