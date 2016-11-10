
import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var ipText: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    
    //
    var previousjNetPoint:CGPoint!
    var lastjNetPoint:CGPoint!
    
    var lastPoint:CGPoint!
    var isSwiping:Bool!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        red   = (0.0/255.0)
        green = (0.0/255.0)
        blue  = (0.0/255.0)
        
        print(self.getIp());
        
    }
    
    
    func getIp() -> String {
        return ipText.text!;
    }

    
    @IBAction func onEditClick(sender: UIBarButtonItem) {
        ipText.userInteractionEnabled = !ipText.userInteractionEnabled
    }
    
    @IBAction func saveImage(sender: AnyObject) {
        if self.imageView.image == nil{
            return
        }
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!,self, #selector(ViewController.image(_:withPotentialError:contextInfo:)), nil)
    }
    
    @IBAction func undoDrawing(sender: AnyObject) {
        self.imageView.image = nil
    }
    
    func image(image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
        UIAlertView(title: nil, message: "Image successfully saved to Photos library", delegate: nil, cancelButtonTitle: "Dismiss").show()
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Touch events
    override func touchesBegan(touches: Set<UITouch>,
        withEvent event: UIEvent?){
            isSwiping    = false
            if let touch = touches.first{
                lastPoint = touch.locationInView(imageView)
                previousjNetPoint = lastPoint;
            }
    }
    
    override func touchesMoved(touches: Set<UITouch>,
        withEvent event: UIEvent?){
    
            isSwiping = true;
            if let touch = touches.first{
                let currentPoint = touch.locationInView(imageView)
                UIGraphicsBeginImageContext(self.imageView.frame.size)
                self.imageView.image?.drawInRect(CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height))
                CGContextMoveToPoint(UIGraphicsGetCurrentContext()!, lastPoint.x, lastPoint.y)
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext()!, currentPoint.x, currentPoint.y)
                CGContextSetLineCap(UIGraphicsGetCurrentContext()!,CGLineCap.Round)
                CGContextSetLineWidth(UIGraphicsGetCurrentContext()!, 9.0)
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext()!,red, green, blue, 1.0)
                CGContextStrokePath(UIGraphicsGetCurrentContext()!)
                self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                //lastPoint
                if(getDistance(lastPoint, p2: currentPoint) >= 5){
                   sendEvent(lastPoint, currentPoint: currentPoint)
                }
                
                
                lastPoint = currentPoint
            }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
            if(!isSwiping) {
                // This is a single touch, draw a point
                UIGraphicsBeginImageContext(self.imageView.frame.size)
                self.imageView.image?.drawInRect(CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height))
                CGContextSetLineCap(UIGraphicsGetCurrentContext()!, CGLineCap.Round)
                CGContextSetLineWidth(UIGraphicsGetCurrentContext()!, 9.0)
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext()!, red, green, blue, 1.0)
                CGContextMoveToPoint(UIGraphicsGetCurrentContext()!, lastPoint.x, lastPoint.y)
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext()!, lastPoint.x, lastPoint.y)
                CGContextStrokePath(UIGraphicsGetCurrentContext()!)
                self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        
            //if let touch = touches.first{
            //    lastjNetPoint = touch.locationInView(imageView)
            //    sendEvent(previousjNetPoint, currentPoint: lastjNetPoint)
            //}
        
           /*if let touch = touches.first {
              let currentPoint = touch.locationInView(imageView)
              sendEvent(lastPoint, currentPoint: currentPoint)
           }*/
    }


    func sendEvent(lastPoint: CGPoint, currentPoint:CGPoint){
       let distance: (Int)  = Int(getDistance(lastPoint, p2: currentPoint))
        
       let ip: String = self.getIp()
       let step : Int = distance;
    
       var x:Int = step
    
       if lastPoint.x > currentPoint.x {
          x = -step
       }
    
       var y:Int = step
    
       if lastPoint.y > currentPoint.y {
          y = -step
       }
    
       let url = "http://\(ip):2013/mousemove?x=\(x)&y=\(y)"
        
       Utils.doGet(url)
    
       print("Called \(url)");

       print("LAST ==>  X=\(lastPoint.x) | Y=\(lastPoint.y) | CURRENT ==>  X=\(currentPoint.x) | Y=\(currentPoint.y) ");
    
    }
    
    func getDistance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let xDist: CGFloat = (p2.x - p1.x)
        let yDist: CGFloat = (p2.y - p1.y)
        //CGPoint yDist = (p2.y - p1.y);
        //CGPoint distance = sqrt((xDist * xDist) + (yDist * yDist));
        let distance: CGFloat = sqrt((xDist * xDist) + (yDist * yDist))
        
        print("distance ==> \(distance)")
        
        return distance;
    }
    
    //func calc(from: CGPoint, to: CGPoint) -> CGFloat {
    //    return sqrt(CGPoint(from, to: to))
    //}

   
}
