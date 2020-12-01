//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Rajha Fajardo de Alencar Marcal on 18/11/20.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {// aqui foi criado um protocolo para tratar dos botoes de cancelar e editar um item.
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate { //Essa ViewController trata da tela onde se adiciona novos item a uma lista.
    @IBOutlet weak var textField: UITextField! // declaração de outlets da tela.
    @IBOutlet weak var doneBarButton: UIBarButtonItem!// declaração de outlets da tela.
    weak var delegate: ItemDetailViewControllerDelegate? //cria uma instancia de ItemDetailViewControllerDelegate para usar dentro da classe.
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {//Essa função é chamada toda vez que abre o app. Então tem que colocar aqui tudo que quer que faz só uma vez, ou seja, só quando iniciar o app. É chamada apenas uma vez durante o ciclo de vida.
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never // configura o titulo da tela para não ser grande.
        if let item = itemToEdit { // cria o objeto item do tipo itemToEdit, e logo verifica se tem algo dentro,para depois editar o título e habilitar o botão done.
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder() // 15 - Isso tem a ver com aquela setinha que determina qual tela será chamada primeiro quando abre o app pela primeira vez?
    }
    
    // MARK: - Actions
    @IBAction func cancel() { // função que trata do funcionamento do botão cancel.
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() { // função que trata do funcionamento do botão done. Verifica se existe algo dentro do texto field, para então habilitar o botão done.
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? { // 16- Realmente não entendi o que essa função faz. Nem faz sentido.
        return nil
    }
    
    // MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // Função que recebe 3 parâmetros, retorna um boolean e edita o objeto textField.
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {// Função que recebe um parâmetro, retorna um boolean e habilita o botão done.
        doneBarButton.isEnabled = false
        return true
    }
}
