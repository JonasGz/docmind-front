import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_icons.dart';

/// Campo de busca da biblioteca. Filtra em memória — o backend não expõe
/// parâmetro de busca em `GET /documents`.
class DocumentsSearchField extends StatefulWidget {
  const DocumentsSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<DocumentsSearchField> createState() => _DocumentsSearchFieldState();
}

class _DocumentsSearchFieldState extends State<DocumentsSearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.search,
      style: AppTypography.body.copyWith(
        fontSize: 13.5,
        color: AppColors.blue900,
      ),
      decoration: InputDecoration(
        hintText: 'Buscar documento',
        isDense: true,
        constraints: const BoxConstraints(minHeight: AppSize.minTouchTarget),
        prefixIcon: const Icon(
          AppIcons.search,
          size: 15,
          color: AppColors.gray400,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close, size: 16),
                color: AppColors.gray400,
                tooltip: 'Limpar busca',
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                  setState(() {});
                },
              ),
      ),
    );
  }
}
