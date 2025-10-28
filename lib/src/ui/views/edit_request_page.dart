import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_inspector/src/loggers/http_dio_logger.dart';
import 'package:http_inspector/src/models/network/http_record.dart';

class EditRequestPage extends StatefulWidget {
  final HttpRecord record;

  const EditRequestPage({
    super.key,
    required this.record,
  });

  @override
  State<EditRequestPage> createState() => _EditRequestPageState();
}

class _EditRequestPageState extends State<EditRequestPage> {
  late TextEditingController _urlController;
  late TextEditingController _bodyController;
  late String _method;
  late Map<String, String> _headers;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(
        text: widget.record.requestOptions.uri.toString());
    _bodyController = TextEditingController(
        text: widget.record.requestOptions.data?.toString() ?? '');
    _method = widget.record.requestOptions.method;
    _headers = widget.record.requestOptions.headers
        .map((k, v) => MapEntry(k, v.toString()));
  }

  @override
  void dispose() {
    _urlController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit & Resend'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _resendRequest,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildMethodDropdown(),
            const SizedBox(height: 16),
            _buildUrlTextField(),
            const SizedBox(height: 16),
            _buildHeaders(),
            const SizedBox(height: 16),
            _buildBodyTextField(),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodDropdown() {
    return DropdownButtonFormField<String>(
      value: _method,
      items: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH']
          .map((method) => DropdownMenuItem(
                value: method,
                child: Text(method),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _method = value;
          });
        }
      },
      decoration: const InputDecoration(
        labelText: 'Method',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildUrlTextField() {
    return TextField(
      controller: _urlController,
      decoration: const InputDecoration(
        labelText: 'URL',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildHeaders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Headers',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ..._headers.entries.map((entry) {
          return Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: entry.key,
                  onChanged: (newKey) {
                    setState(() {
                      final value = _headers.remove(entry.key);
                      _headers[newKey] = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: entry.value,
                  onChanged: (newValue) {
                    setState(() {
                      _headers[entry.key] = newValue;
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  setState(() {
                    _headers.remove(entry.key);
                  });
                },
              ),
            ],
          );
        }).toList(),
        TextButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Header'),
          onPressed: () {
            setState(() {
              _headers[''] = '';
            });
          },
        ),
      ],
    );
  }

  Widget _buildBodyTextField() {
    return TextField(
      controller: _bodyController,
      maxLines: null,
      decoration: const InputDecoration(
        labelText: 'Body',
        border: OutlineInputBorder(),
      ),
    );
  }

  void _resendRequest() async {
    final dio = Dio();
    try {
      final response = await dio.request(
        _urlController.text,
        data: _bodyController.text,
        options: Options(
          method: _method,
          headers: _headers,
        ),
      );
      HttpDioLogger.instance.log(response.requestOptions);
      HttpDioLogger.instance.log(response);
    } on DioException catch (e) {
      HttpDioLogger.instance.log(e.requestOptions);
      HttpDioLogger.instance.log(e);
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request resent')),
        );
      }
    }
  }
}
