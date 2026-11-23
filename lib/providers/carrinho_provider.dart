import 'package:flutter/foundation.dart';
import '../models/produto.dart';

class CarrinhoProvider extends ChangeNotifier {
  final Map<Produto, int> _itens = {};
  double _descontoPercentual = 0.0;

  Map<Produto, int> get itens => Map.unmodifiable(_itens);

  int get quantidade => _itens.values.fold(0, (soma, qtd) => soma + qtd);

  bool get temCupom => _descontoPercentual > 0;

  double get valorTotal {
    double total = 0.0;
    _itens.forEach((produto, qtd) {
      total += produto.preco * qtd;
    });
    return total * (1 - _descontoPercentual);
  }

  void adicionar(Produto produto) {
    if (_itens.containsKey(produto)) {
      _itens[produto] = _itens[produto]! + 1;
    } else {
      _itens[produto] = 1;
    }
    notifyListeners();
  }

  void diminuirQuantidade(Produto produto) {
    if (!_itens.containsKey(produto)) return;
    if (_itens[produto]! > 1) {
      _itens[produto] = _itens[produto]! - 1;
    } else {
      _itens.remove(produto);
    }
    notifyListeners();
  }

  void remover(Produto produto) {
    _itens.remove(produto);
    notifyListeners();
  }

  bool aplicarCupom(String codigo) {
    if (codigo.trim().toUpperCase() == 'SENAI10') {
      _descontoPercentual = 0.10;
      notifyListeners();
      return true;
    }
    return false;
  }

  void limpar() {
    _itens.clear();
    _descontoPercentual = 0.0;
    notifyListeners();
  }
}
