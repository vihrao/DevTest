//
//  AddContactTableViewController.swift
//  DevTest
//
//  Created by viswanatha rao on 7/12/20.
//  Copyright © 2020 viswanatha rao. All rights reserved.
//

import UIKit
/*
 1. All the UI elements have been manually dragged and dropped on the view and hand wired. Rewrite everything using Swift UI scripts
 2. Rewite button 'Choose an Image' button to actually look like a button; be creative
 3. Resdesign section 2 layout of UI elements as you choose to make it user friendly
 4. Place a transparent button with text 'choose an image' on the  UIImageView and when user presses the button then open up image picker, after user picks image then display the image (OPTIONAL)
 5. Note that when user types phone number it accepts only numbers. Write a similar input checker code that check if email is valid and follows xxx@yyy.zzz format
 6. When user presses save button, checkUserInput checks UI elements. Rewrite this. Make sure there are no empty fields. If empty field is found or if image has not been chosen then display a alert controller that shows which field is missing. Hint: Display the placeholder text so user knows which field is missing. Also may be change the color of the UI element that has missing or wrong input.
 8. If user enters wrong text Ex: user inputs numbers in name field then show a pop up with a message. Design generic popup to show which UI element had wrong input, what is wrong and suggest correction.
 9. MOST important make the UI very pretty and no lines in between UI elements.
 10. Define radio buttons with the 'pickerDataUserTypeOptions' defined below and when user selects one of them, then populate the UserCategory label
 12. Define two checkboxes with values 'Energy Seller', Energy Buyer' and when user selects one or both, populate the userTypeLabel with chosen values> if he chooses both then display 'Seller and Buyer, otherwise display the chosen chekbox
 11. Use a UIViewController and duplicate all this in that viewcontroller and make it work
 
 */
protocol ContactDelegate{
    func contactData(contactFullName: String)
}
class AddContactTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    public var pickerDataUserTypeOptions:Array = ["Consume(Household)", "Consume & Generate(Household)", "Consume(Commercial)", "Consume & Generate(Commercial)", "Generate(Commercial)"]

  
    var defaultCategoryTypeIndex: Int = 1
   
    var myDelegate: ContactDelegate? = nil
    var status:String? = nil
    
    
    @IBAction func save(_ sender: Any) {
        if (self.checkInput() == false) {
            return
        }
        self.myDelegate?.contactData(contactFullName: (firstNameTextField.text!) + " " + (lastNameTextField.text!))
        self.navigationController!.popViewController(animated: true)
    }
    func checkInput () -> Bool {
        let alertController = UIAlertController(title: "UIAlertController", message: "Input Validation", preferredStyle: .alert)
        if (
            ( (firstNameTextField.text?.count == 0) ||
                (lastNameTextField.text?.count == 0) ||
                (phoneTextField.text?.count == 0) ||
                (emailTextField.text?.count == 0) ) ){
            alertController.message = "Missing input"
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    @IBOutlet weak var firstNameTextField: UITextField!{
        didSet{
        firstNameTextField.delegate = self
        firstNameTextField.tag = 1
        firstNameTextField.autocorrectionType = UITextAutocorrectionType.no
        //firstNameTextField.backgroundColor = self.UIColorgrey75
        }
    }
    @IBOutlet weak var lastNameTextField: UITextField!{
        didSet{
            lastNameTextField.delegate = self
            lastNameTextField.tag = 2
            lastNameTextField.autocorrectionType = UITextAutocorrectionType.no
            //lastNameTextField.backgroundColor = self.UIColorgrey75
        }
    }
    
    @IBOutlet weak var phoneTextField: UITextField!{
        didSet{
            phoneTextField.delegate = self
            phoneTextField.tag = 3
            phoneTextField.autocorrectionType = UITextAutocorrectionType.no
            //phoneTextField.backgroundColor = self.UIColorgrey75
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.delegate = self
            emailTextField.tag = 4
            emailTextField.autocorrectionType = UITextAutocorrectionType.no
            //emailTextField.backgroundColor = self.UIColorgrey75
        }
    }
    
    @IBOutlet weak var contactImageView: UIImageView!
    
    @IBAction func chooseImage(_ sender: Any) {
        pickImage()
    }
    func pickImage () {
        let imagePicker:UIImagePickerController = UIImagePickerController()
        /*
         when you set the imagepicker delgate to self, you are actually setting the delegate to UINavigationControllerDelegate
         which is image picker's delegate object
         */
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        // present the view controller with image picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    @objc func selectImage(_ sender: UITapGestureRecognizer){
        let imagePicker:UIImagePickerController = UIImagePickerController()
        /*
         when you set the imagepicker delgate to self, you are actually setting the delegate to UINavigationControllerDelegate
         which is image picker's delegate object
         */
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        // present the view controller with image picker
        self.present(imagePicker, animated: true, completion: nil)
        //chooseImageLabel.isHidden = true
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*
         Pick and image size it and display it
         */
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // small picture for display
        let smallPicture = scaleImage(image: pickedImage, newSize: CGSize(width: 60, height: 60))
        
        // assign the image to the frame of UIImageView
        var sizeOfImageView:CGRect = contactImageView.frame
        sizeOfImageView.size = smallPicture.size
        contactImageView.frame = sizeOfImageView
        
        contactImageView.image = smallPicture
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // delegate methods for imagePicker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func scaleImage(image:UIImage, newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x:0, y:0, width:newSize.width, height:newSize.height))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @IBOutlet weak var handleTextField: UITextField!{
        didSet{
            handleTextField.delegate = self
            handleTextField.tag = 5
            handleTextField.autocorrectionType = UITextAutocorrectionType.no
            //handleTextFieldbackgroundColor = self.UIColorgrey75
        }
    }
   

    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.tag == 3) {
            guard CharacterSet(charactersIn: "0123456789-").isSuperset(of: CharacterSet(charactersIn: string)) else {
                return false
            }
        }
        return true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
    
    @IBOutlet weak var userCategoryLabel: UILabel!
    
    @IBOutlet weak var userTypeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
