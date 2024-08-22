import 'package:flutter/material.dart';

class SegundaTela extends StatefulWidget{// SEGUNDA TELA
  final String tituloInicial;
  final String descricaoInicial;
  final int? index;

  SegundaTela({
    required this.tituloInicial,
    required this.descricaoInicial,
    this.index
  });

  @override
  State<SegundaTela> createState() =>_SegundaTela();
}

class _SegundaTela extends State<SegundaTela> {// STATE
  late final _tituloController;
  late final _descricaoController;

  @override
  void initState() {
    super.initState();

    _tituloController =
        TextEditingController(
            text: widget.index != null ? widget.tituloInicial : null
        );

    _descricaoController =
        TextEditingController(
            text: widget.index != null ? widget.descricaoInicial : null
        );
  }

  @override
  void dispose() {
    super.dispose();
    _tituloController.dispose();
    _descricaoController.dispose();
  }

  @override
  Widget build(BuildContext context) {// Widget
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              children: [// CAMPOS DE TEXTO
                TextField(
                  controller: _tituloController,
                  decoration: const InputDecoration(hintText: 'Título'),
                ),
                TextField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(hintText: 'Digite seu texto aqui...'),
                  maxLines: null,
                ),
                SizedBox(// BOTOES
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context,{
                            'titulo': _tituloController.text,
                            'descricao': _descricaoController.text
                          });
                        },
                        child: const Text('Finalizar Lembrete'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
      )
    );
  }
}