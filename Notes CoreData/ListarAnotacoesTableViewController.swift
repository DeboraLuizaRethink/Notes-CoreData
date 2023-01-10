//
//  ListarAnotacoesTableViewController.swift
//  Notes CoreData
//
//  Created by Debora Luiza on 10/01/23.
//

import UIKit
import CoreData

class ListarAnotacoesTableViewController: UITableViewController {
    
    var context: NSManagedObjectContext!
    var anotacoes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    override func viewDidAppear(_ animated: Bool) {
        self.recuperarAnotacoes()
    }
    
    func recuperarAnotacoes() {
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Anotacao")
        
        do {
            let anotacoesRecuperadas = try context.fetch(requisicao)
            self.anotacoes = anotacoesRecuperadas as! [NSManagedObject]
            self.tableView.reloadData()
            
        } catch let erro {
            print("Erro ao recuperar anotação: \(erro.localizedDescription)")
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.anotacoes.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let anotacao = self.anotacoes[indexPath.row]
        self.performSegue(withIdentifier: "verAnotacaco", sender: anotacao)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verAnotacaco" {
            
            let viewDestino = segue.destination as! AnotacaoViewController
            viewDestino.anotacaco = sender as? NSManagedObject
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)

        let anotacaco = self.anotacoes[indexPath.row]
        let textoRecuperado = anotacaco.value(forKey: "texto")
        let dataRecuperada = anotacaco.value(forKey: "data")
        
        //formatar data
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy hh:mm"
        
        let novaData = dateFormater.string(from: dataRecuperada as! Date)
        
        cell.textLabel?.text = textoRecuperado as? String
        cell.detailTextLabel?.text = String(describing: novaData)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            let indice = indexPath.row
            let anotacao = self.anotacoes[indice]
            
            self.context.delete(anotacao)
            self.anotacoes.remove(at: indice)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try self.context.save()
            } catch let erro {
                print(erro)
            }
            
        }
        
    }


}
