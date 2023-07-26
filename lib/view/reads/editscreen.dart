import 'package:flutter/material.dart';
import 'package:barcode/model/produto.dart';
import 'package:barcode/main.dart';


class EditScreen extends StatefulWidget  {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _noteInputController = TextEditingController();

  Future<void> _addNote() async {
    if (_noteInputController.text.isEmpty) return;
    await objectbox.addProduto(_noteInputController.text);
    _noteInputController.text = '';
  }

  @override
  void dispose() {
    _noteInputController.dispose();
    super.dispose();
  }

  GestureDetector Function(BuildContext, int) _itemBuilder(List<Produto> produto) =>
          (BuildContext context, int index) => GestureDetector(

          onDoubleTap: () => objectbox.removeProduto(produto[index].id),
          child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    border:
                    Border(bottom: BorderSide(color: Colors.black12))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        produto[index].barcode,
                        style: const TextStyle(
                          fontSize: 15.0,
                        ),
                        // Provide a Key for the integration test
                        key: Key('list_item_$index'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          'Quantidade : ${produto[index].quantidade.toString()}',
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: 'Informe Produto'),
                      controller: _noteInputController,
                      onSubmitted: (value) => _addNote(),
                      // Provide a Key for the integration test
                      key: const Key('input'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, right: 10.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '2 clicks para remover',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Expanded(
          child: StreamBuilder<List<Produto>>(
              stream: objectbox.getProdutos(),
              builder: (context, snapshot) => ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                  itemBuilder: _itemBuilder(snapshot.data ?? []))))
    ]),
    // We need a separate submit button because flutter_driver integration
    // test doesn't support submitting a TextField using "enter" key.
    // See https://github.com/flutter/flutter/issues/9383
    floatingActionButton: FloatingActionButton(
      key: const Key('submit'),
      onPressed: _addNote,
      child: const Icon(Icons.add),
    ),
  );
}