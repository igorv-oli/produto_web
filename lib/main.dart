import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:produto_web/models/produtoModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Listagem de produtos',
      home: MyHomePage(title: 'Listagem dos produtos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ProdutoModel> produtos = [];

  Future<void> createProduto(Map<String, dynamic> produto) async {
    final url = Uri.parse('http://localhost:3000/produtos');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(produto),
      );

      if (response.statusCode == 201) {
        print('Dados enviados com sucesso');
      } else {
        throw Exception('Erro na requisição POST: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  Future<void> getProduto() async {
    final url = Uri.parse('http://localhost:3000/produtos');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          produtos =
              data.map((produto) => ProdutoModel.fromJson(produto)).toList();
        });
        print(data);
      } else {
        throw Exception('Erro na requisição GET: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  Future<void> getProdutoById(int id) async {
    final url = Uri.parse('http://localhost:3000/produtos/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
      } else {
        throw Exception('Erro na requisição GET: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  Future<void> updateProduto(int id, Map<String, dynamic> produto) async {
    final url = Uri.parse('http://localhost:3000/produtos/$id');

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(produto),
      );

      if (response.statusCode == 200) {
        print('Dados atualizados com sucesso');
      } else {
        throw Exception('Erro na requisição PUT: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  Future<void> deleteProduto(int id) async {
    final url = Uri.parse('http://localhost:3000/produtos/$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Dados deletados com sucesso');
      } else {
        throw Exception('Erro na requisição DELETE: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  void modalCreate() {}

  @override
  void initState() {
    super.initState();
    // Map<String, dynamic> p1 = {"nome": "Maça", "preco": 5.99, "estoque": 2};
    // createProduto(p1);
    getProduto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        centerTitle: true,
      ),
      body: produtos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return ListTile(
                  title: Text(
                    produto.nome,
                    textAlign: TextAlign.center,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Editar produto'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Fechar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                // title: Text('Deseja realmente deletar o produto?'),
                                content:
                                    Text('Deseja realmente deletar o produto?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      deleteProduto(produto.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Confirmar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              padding: EdgeInsets.all(16),
              separatorBuilder: (_, __) => Divider(),
              itemCount: produtos.length),
      floatingActionButton: FloatingActionButton(
        onPressed: modalCreate,
        tooltip: 'Adicionar Produto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
