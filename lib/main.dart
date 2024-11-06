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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Listagem de produtos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Listagem dos produtos'),
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
        print('Erro na requisição POST: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
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
        print('Erro na requisição GET: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
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
        print('Erro na requisição PUT: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  Future<void> deleteProduto(int id) async {
    final url = Uri.parse('http://localhost:3000/produtos/$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Dados deletados com sucesso');
      } else {
        print('Erro na requisição DELETE: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  @override
  void initState() {
    // Map<String, dynamic> p1 = {"nome": "Maca", "preco": 5.99, "estoque": 2};
    super.initState();
    // print(produtos);
    getProduto();
    // print(produtos);
    // getProduto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        centerTitle: true,
      ),
      body: produtos.isEmpty
          ? Center(
              child: CircularProgressIndicator()) // Indicador de carregamento
          : ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(produto.nome[0]), // Inicial do nome
                  ),
                  title: Text(produto.nome),
                  subtitle: Text('Nome: ${produto.nome}\n'),
                  isThreeLine: true,
                );
              },
            ),
    );
  }
}
