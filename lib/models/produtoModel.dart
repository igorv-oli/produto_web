class ProdutoModel {
  String nome;
  double preco;
  int estoque;

  ProdutoModel({
    required this.nome,
    required this.preco,
    required this.estoque,
  });

  factory ProdutoModel.fromJson(Map<String, dynamic> json) {
    return ProdutoModel(
      nome: json['nome'],
      preco: json['preco'],
      estoque: json['estoque'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'preco': preco,
      'estoque': estoque,
    };
  }

  static List<ProdutoModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ProdutoModel.fromJson(json)).toList();
  }
}
