//
//  ViewController.swift
//  Checklists
//
//  Created by Rajha Fajardo de Alencar Marcal on 17/11/20.
//
import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate { // Essa é a ViewController que trata da segunda tela, a que abre uma lista específica.
    var checklist: Checklist! // aqui é uma instancia do objeto checklist, para poder ser usado neste arquivo.
    
    override func viewDidLoad() { //Essa função é chamada toda vez que abre o app. Então tem que colocar aqui tudo que quer que faz só uma vez, ou seja, só quando iniciar o app. ë chamada apaneas uma vez durante o ciclo de vida.
        super.viewDidLoad()
        // Disable large titles for this view controller
        navigationItem.largeTitleDisplayMode = .never // isso que a linha de cima disse mesmo.
        title = checklist.name // aqui manda colocar o titulo da tela de acordo com o nome da lista.
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) { // é um função que trata do check. Faz ele aparecer ou desaparecer da tela. Quando a celula é clicada, verifica se naquela célula há umm "check", se não tiver ele acrescenta, se tiver ele tira.
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        //label.text = item.text
        label.text = "\(item.itemID): \(item.text)"
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //é uma função relacionada a segue. Qunado usa o Story Board tem que usar ela.
        if segue.identifier == "AddItem" { // verifica se existe a segue com o nome "AddItem".
            let controller = segue.destination as! ItemDetailViewController// 13 - Não entendi o que isso faz.
            controller.delegate = self
        } else if segue.identifier == "EditItem" {// se o nome da segue não for "AddItem", verifica se o nome é "EditItem".
            let controller = segue.destination as! ItemDetailViewController //manda a segue apontar para ItemDetailViewController.
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) { // verifca se existe algo dentro desde obejto e então manda executar a linha debaixo.
                controller.itemToEdit = checklist.items[indexPath.row] //permite editar a célula.
            }
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // é uma função que retorna um Int, e define quantas seções terão na table view. Aqui se define que o número de seções será iigual a aqauntidade de objetos items de checklist que contiver na lista.
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {// é uma função que retorna um objeto do tipo UITableViewCell. Ela irá retornar a célula contida na tableView.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)//aqui é criada a célula e já seta o identifier dela, que é ChecklistItem.
        
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item) //chama uma funçao passando 2 parametros
        configureCheckmark(for: cell, with: item) //chama uma funçao passando 2 parametros
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // é uma função que não retorna nada. Trata de tableView recebe 2 parâmetros: a tableView e o indexPath.
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { // é uma função que não retorna nada. Trata de tableView recebe 3 parâmetros.Trata de um evento que deve acontecer em cada linha selecionada.
        checklist.items.remove(at: indexPath.row)// manda remover a célula da determinada linha. No caso, é determinda pelo indexPath.
        
        let indexPaths = [indexPath]// cria uma array do tipo indexPath.
        tableView.deleteRows(at: indexPaths, with: .automatic) //14 - acho que configura aquele swipe to delete, acho que é isso que o .automatic faz. É isso?
    }
    
    // MARK: - Add Item ViewController Delegates
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {// é uma função que não retorna nada e recebe 1 parâmetro.
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) { // é uma função que não retorna nada e recebe 2 parâmetros.
        let newRowIndex = checklist.items.count //cria um objeto que recebe a quantidade de items que há dentro de checklist.
        checklist.items.append(item)//acrescenta item ao array de checklist.
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) { // é uma função que não retorna nada e recebe 2 parâmetros.
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

