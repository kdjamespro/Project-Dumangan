import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/model/attribute_mapping.dart';
import 'package:project_dumangan/services/warning_message.dart';
import 'package:project_dumangan/widget/drop_down.dart';
import 'package:provider/provider.dart';

import '/bloc/cross_checking_bloc.dart';

class ColumnsTable extends StatefulWidget {
  ColumnsTable(
      {Key? key, required this.data, required this.crossCheck, this.file})
      : super(key: key);

  Map<String, List> data;
  final bool crossCheck;
  final File? file;

  @override
  State<ColumnsTable> createState() => _ColumnsTableState();
}

class _ColumnsTableState extends State<ColumnsTable> {
  String? value;
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Validation of File Columns',
          style: FluentTheme.of(context).typography.title,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button(
                  child: const Text('Reupload File'),
                  onPressed: () {
                    context
                        .read<CrossCheckingBloc>()
                        .add(CrossChekingDisable());
                    Provider.of<AttributeMapping>(context, listen: false)
                        .removeAll();
                  },
                ),
                FilledButton(
                    child: const Text('Match File'),
                    onPressed: () {
                      if (Provider.of<AttributeMapping>(context, listen: false)
                          .requiredAttributeExists()) {
                        if (widget.crossCheck) {
                          context.read<CrossCheckingBloc>().add(
                              CrossCheckingProceed(
                                  file: widget.file as File,
                                  crossCheck: widget.crossCheck,
                                  data: widget.data));
                        } else {
                          context.read<CrossCheckingBloc>().add(
                              CrossCheckingProcess(
                                  db: Provider.of<MyDatabase>(context,
                                      listen: false),
                                  isEnabled: widget.crossCheck,
                                  data: widget.data,
                                  attributeMap: Provider.of<AttributeMapping>(
                                      context,
                                      listen: false)));
                        }
                      } else {
                        showWarningMessage(
                            context: context,
                            title: 'Unassigned Attributes',
                            message:
                                'Please map the Full Name and Email attribute to a column');
                      }
                    })
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: mat.Material(
                  color: FluentTheme.of(context).scaffoldBackgroundColor,
                  child: SingleChildScrollView(
                    child: mat.DataTable(
                      columns: ['File Columns', 'Values', 'Map to', 'Remove']
                          .map((e) => mat.DataColumn(label: Text(e)))
                          .toList(),
                      rows: widget.data.isNotEmpty
                          ? widget.data.entries.map((e) {
                              return mat.DataRow(
                                key: ValueKey(e.key),
                                cells: <mat.DataCell>[
                                  mat.DataCell(
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        child: Text(
                                          e.key.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                  ),
                                  mat.DataCell(Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Text(
                                      e.value.join(', '),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  )),
                                  mat.DataCell(
                                    DropDownMapping(
                                      column: e.key,
                                    ),
                                  ),
                                  mat.DataCell(
                                    IconButton(
                                      icon: const Icon(
                                        FluentIcons.delete,
                                        color: mat.Colors.blue,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (widget.data.length - 1 < 3) {
                                            showWarningMessage(
                                                context: context,
                                                title: 'Column Length Error',
                                                message:
                                                    'Atleast three columns is required for the data attributes');
                                          } else {
                                            Provider.of<AttributeMapping>(
                                                    context,
                                                    listen: false)
                                                .removeAttribute(e.key);
                                            widget.data.remove(e.key);
                                          }
                                          print(widget.data.keys);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList()
                          : [],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
