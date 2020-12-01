//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Rajha Fajardo de Alencar Marcal on 23/11/20.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {// aqui foi criado um protocolo para tratar dos botoes de cancelar e editar um item, assim como na tela anterior.
    // 17 - Se o protocolo é o mesmo, ele ter que ser criado em cada tela que for usar? Não posso criar um file para o protocolo e criar uma instancia onde quiser usar? O nome dos protocolos são diferentesmas a função que exercem é a mesma, correto? E não poderia usar m protocolo com o mesmo nome nas duas telas? Por isso teve que trocar o nome?
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
  func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
  func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate { //Essa ViewController trata da tela onde se adiciona novas listas, ou seja, adiciona um novo array ao array.
  @IBOutlet weak var textField: UITextField! // declaração de outlets da tela.
  @IBOutlet weak var doneBarButton: UIBarButtonItem! // declaração de outlets da tela.

    weak var delegate: ListDetailViewControllerDelegate? //cria uma instancia de ListDetailViewControllerDelegate para usar dentro da classe.

  var checklistToEdit: Checklist?

  override func viewDidLoad() {//Essa função é chamada toda vez que abre o app. Então tem que colocar aqui tudo que quer que faz só uma vez, ou seja, só quando iniciar o app. é chamada apenas uma vez durante o ciclo de vida.
    super.viewDidLoad()

    if let checklist = checklistToEdit {// cria o objeto item do tipo checklist, e logo verifica se tem algo dentro,para depois editar o título e habilitar o botão done.
      title = "Edit Checklist"
      textField.text = checklist.name
      doneBarButton.isEnabled = true
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }

  // MARK: - Actions
  @IBAction func cancel() { // função que trata do funcionamento do botão cancel.
    delegate?.listDetailViewControllerDidCancel(self)
  }

  @IBAction func done() { // função que trata do funcionamento do botão done. Verifica se existe algo dentro do texto field, para então habilitar o botão done.
    if let checklist = checklistToEdit {
      checklist.name = textField.text!
      delegate?.listDetailViewController(self, didFinishEditing: checklist)
    } else {
      let checklist = Checklist(name: textField.text!)
      delegate?.listDetailViewController(self, didFinishAdding: checklist)
    }
  }

  // MARK: - Table View Delegates
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? { //Já deixei como dúvida na tela anterior.
    return nil
  }

  // MARK: - Text Field Delegates
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { //18 - Faz o mesmo que na tela anterior, mas não entendi o que faz. Está confuso.
    let oldText = textField.text!
    let stringRange = Range(range, in: oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    doneBarButton.isEnabled = !newText.isEmpty
    return true
  }

  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    doneBarButton.isEnabled = false
    return true
  }
}


