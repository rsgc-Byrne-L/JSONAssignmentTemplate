//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

class ViewController : UIViewController {
    
    // Views that need to be accessible to all methods
    let jsonResult = UILabel()
    
    let field = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    
    //let label2 = UILabel()
    
    var temperatureFinal : Double = 0
    var temperatureFinalF : Double = 0
    var nameFinal : AnyObject = ""
    var countryFinal : AnyObject = ""
    var humidityFinal : AnyObject = 0
    
    // If data is successfully retrieved from the server, we can parse it here
    func parseMyJSON(theData : NSData) {
        
        // Print the provided data
        print("")
        print("====== the data provided to parseMyJSON is as follows ======")
        print(theData)
        
        // De-serializing JSON can throw errors, so should be inside a do-catch structure
        do {
            
            // Do the initial de-serialization
            // Source JSON is here:
            // http://api.openweathermap.org/data/2.5/weather?q=Toronto,ca&appid=6f3d9ef1a77a8b37019ebe9802e7eadc
            //
            let json = try NSJSONSerialization.JSONObjectWithData(theData, options: NSJSONReadingOptions.AllowFragments) as! AnyObject
            
            // Print retrieved JSON
            print("")
            print("====== the retrieved JSON is as follows ======")
            print(json)
            
            // Now we can parse this...
            print("")
            print("Now, add your parsing code here...")
            
            if let weatherData = json as? [String : AnyObject] {
                
                // If this worked, I have a dictionary
                print("=======")
                print("The value for the 'main' key is: ")
                print(weatherData["main"])
                print("=======")
                
                // If this worked, I have a dictionary
                print("=======")
                print("The value for the 'weather' key is: ")
                print(weatherData["weather"])
                print("=======")
                
                print(weatherData["name"])
                let name = weatherData["name"]
                
                
                if let weatherMain = weatherData["main"] as? [String : AnyObject] {
                    
                    // If this worked, we can use this data
                    print("======= Temperature =======")
                    print(weatherMain["temp"])
                    let temperatureK : Double = weatherMain["temp"] as! Double
                    // We create celcius using our data from our source
                    let temperatureC = temperatureK - 273.15
                    // We create fehrinheight using our data from our source
                    let temperatureF = temperatureK*(9/5)-459.67
                    // We round celcius so its not a number with many decimal places
                    temperatureFinal = Double(round(1000*temperatureC)/1000)
                    // We round fehrinheight so its not a number with many decimal places
                    temperatureFinalF = Double(round(1000*temperatureF)/1000)
                    
                    
                    print("\(temperatureC)°C")
                    print ("======= Humidity =======")
                    print(weatherMain["humidity"])
                    let humidity = weatherMain["humidity"]
                    humidityFinal = humidity!
            
                }
                
                if let weatherSystem = weatherData["sys"] as? [String : AnyObject] {
                    
                    // If this worked, we can use this data
                    print("======= Country =======")
                    print(weatherSystem["country"])
                    let country = weatherSystem["country"]
                    print("\(name),\(country)")
                    nameFinal = name!
                    countryFinal = country!
                    
                }
                
                if let weatherWeather = weatherData["weather"] as? [String : AnyObject] {
                    
                    // If this worked, we can use this data
                    print("======= Temperature =======")
                    print(weatherWeather["weather"])
                    
                }
                
            }
            
            // Now we can update the UI
            // (must be done asynchronously)
            dispatch_async(dispatch_get_main_queue()) {
                self.jsonResult.text = "\(self.temperatureFinal)°C \n\(self.temperatureFinalF)°F \n\(self.humidityFinal)% humidity\n\(self.nameFinal), \(self.countryFinal)"
            }
            
        } catch let error as NSError {
            print ("Failed to load: \(error.localizedDescription)")
        }
        
        
    }
    
    // Set up and begin an asynchronous request for JSON data
    func getMyJSON() {

        // Define a completion handler
        // The completion handler is what gets called when this **asynchronous** network request is completed.
        // This is where we'd process the JSON retrieved
        let myCompletionHandler : (NSData?, NSURLResponse?, NSError?) -> Void = {
            
            (data, response, error) in
            
            // This is the code run when the network request completes
            // When the request completes:
            //
            // data - contains the data from the request
            // response - contains the HTTP response code(s)
            // error - contains any error messages, if applicable
            
            // Cast the NSURLResponse object into an NSHTTPURLResponse objecct
            if let r = response as? NSHTTPURLResponse {
                
                // If the request was successful, parse the given data
                if r.statusCode == 200 {
        
                    // Show debug information (if a request was completed successfully)            
                    print("")
                    print("====== data from the request follows ======")
                    print(data)
                    print("")
                    print("====== response codes from the request follows ======")
                    print(response)
                    print("")
                    print("====== errors from the request follows ======")
                    print(error)
            
                    if let d = data {
                        
                        // Parse the retrieved data
                        self.parseMyJSON(d)
                        
                    }
                    
                }
                
            }
            
        }
        
        let location : String = field.text!
        
        //label2.text = location
        
        // Define a URL to retrieve a JSON file from
        let address : String = "http://api.openweathermap.org/data/2.5/weather?q=\(location)&appid=6f3d9ef1a77a8b37019ebe9802e7eadc"
        
        // Try to make a URL request object
        if let url = NSURL(string: address) {
            
            // We have an valid URL to work with
            print(url)
            
            // Now we create a URL request object
            let urlRequest = NSURLRequest(URL: url)
            
            // Now we need to create an NSURLSession object to send the request to the server
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            // Now we create the data task and specify the completion handler
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: myCompletionHandler)
            
            // Finally, we tell the task to start (despite the fact that the method is named "resume")
            task.resume()
            
        } else {
            
            // The NSURL object could not be created
            print("Error: Cannot create the NSURL object.")
            
        }
        
    }
    
    // This is the method that will run as soon as the view controller is created
    override func viewDidLoad() {
        
        // Sub-classes of UIViewController must invoke the superclass method viewDidLoad in their
        // own version of viewDidLoad()
        super.viewDidLoad()

        // Make the view's background be gray
        view.backgroundColor = UIColor.lightGrayColor()

        /*
         * Further define label that will show JSON data
         */
        
        // Set the label text and appearance
        jsonResult.text = "..."
        jsonResult.font = UIFont.systemFontOfSize(12)
        jsonResult.numberOfLines = 0   // makes number of lines dynamic
        // e.g.: multiple lines will show up
        jsonResult.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        jsonResult.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(jsonResult)
        
        // Set the label text and appearance
        
        field.backgroundColor = UIColor.whiteColor()
        field.placeholder = "Enter location here"
        field.borderStyle = UITextBorderStyle.RoundedRect
        field.font = UIFont.systemFontOfSize(15)
        field.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        field.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        field.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(field)

        /*
         * Add a button
         */
        let getData = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        
        // Make the button, when touched, run the calculate method
        getData.addTarget(self, action: #selector(ViewController.getMyJSON), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Set the button's title
        getData.setTitle("Go!", forState: UIControlState.Normal)
        
        // Required to auto layout this button
        getData.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        // Add the button into the super view
        view.addSubview(getData)
        
        let label1 = UILabel()
        
        // Set the label text and appearance
        label1.text = "Weather"
        label1.font = UIFont.boldSystemFontOfSize(36)
        label1.textAlignment = NSTextAlignment.Center
        
        
        
        // Required to autolayout this label
        label1.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Add the label to the superview
        view.addSubview(label1)
        
        // Set the label text and appearance
        jsonResult.font = UIFont.boldSystemFontOfSize(18)
        
        /*
         * Layout all the interface elements
         */
        
        // This is required to lay out the interface elements
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Create an empty list of constraints
        var allConstraints = [NSLayoutConstraint]()
        
        // Create a dictionary of views that will be used in the layout constraints defined below
        let viewsDictionary : [String : AnyObject] = [
            "title": jsonResult,
            "getData": getData,
            "field" : field,
            "label1" : label1,
            ]
    
        // Define the vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-50-[label1]-50-[field]-50-[title]-50-[getData]",
            options: [],
            metrics: nil,
            views: viewsDictionary)
        
        
        
        // Add the vertical constraints to the list of constraints
        allConstraints += verticalConstraints
        
        NSLayoutConstraint.activateConstraints(allConstraints)
        
    }
    
}

// Embed the view controller in the live view for the current playground page
XCPlaygroundPage.currentPage.liveView = ViewController()
// This playground page needs to continue executing until stopped, since network reqeusts are asynchronous
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
