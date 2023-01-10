//
//  AnotacaoViewController.swift
//  Notes CoreData
//
//  Created by Debora Luiza on 10/01/23.
//

import UIKit
import CoreData

class AnotacaoViewController: UIViewController {

    @IBOutlet weak var texto: UITextView!
    var context: NSManagedObjectContext!
    var anotacaco: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        //configuracoes iniciais
        self.texto.becomeFirstResponder()
       
        if anotacaco != nil {
            if let textorecuperado = anotacaco.value(forKey: "texto"){
                self.texto.text =  String(describing: textorecuperado)
            }
           
        }else{
            self.texto.text = ""
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    @IBAction func salvar(_ sender: Any) {
        if anotacaco != nil {
            self.atualizarAnotacao()
        }else{
            self.salvarAnotacaco()
        }
        
        //retornar pra tela principal
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func atualizarAnotacao(){
        anotacaco.setValue( self.texto.text, forKey: "texto")
        anotacaco.setValue( Date(), forKey: "data")
        
        do {
            try context.save()
            print("Sucesso")
        } catch let erro{
            print("Erro ao salvar anotação: \(erro.localizedDescription)")
        }
        
    }
    
    func salvarAnotacaco(){
        
        // objeto para anotacao
        let novaAnotacao = NSEntityDescription.insertNewObject(forEntityName: "Anotacao", into: context)
        
        //configurar anotacao
        novaAnotacao.setValue(self.texto.text, forKey: "texto")
        novaAnotacao.setValue(Date(), forKey: "data")
        
        do {
            try context.save()
            print("Sucesso")
        } catch let erro{
            print("Erro ao salvar anotação: \(erro.localizedDescription)")
        }
        
        
    }
}
