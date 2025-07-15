import 'package:flutter/material.dart';
import '../../data/models/login/terms_of_service.dart';
import 'package:url_launcher/url_launcher.dart';

class TermCheckbox extends StatefulWidget {
  final TermsOfService termsOfService;
  final bool validation;

  const TermCheckbox({
    super.key,
    required this.termsOfService,
    this.validation = true,
  });

  @override
  State<TermCheckbox> createState() => _TermCheckboxState();
}

class _TermCheckboxState extends State<TermCheckbox> {
  @override
  Widget build(BuildContext context) {
    return CheckboxFormField(
      onChanged: (value) {
        widget.termsOfService.checked = value ?? false;
      },
      initialValue: widget.termsOfService.initialValue,
      title: widget.termsOfService.linkUrl != null
          ? InkWell(
              onTap: () {
                launchUrl(Uri.parse(widget.termsOfService.linkUrl!));
              },
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.termsOfService.text,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.open_in_new,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      size: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    ),
                  ),
                ],
              ),
            )
          : Text(
              widget.termsOfService.text,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.left,
            ),
      validator: (bool? value) {
        if (widget.validation &&
            widget.termsOfService.mandatory &&
            !widget.termsOfService.checked) {
          return widget.termsOfService.validationErrorMessage;
        }
        return null;
      },
    );
  }
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    super.key,
    required Widget title,
    required FormFieldValidator<bool> super.validator,
    bool super.initialValue = false,
    required ValueChanged<bool?> onChanged,
  }) : super(
          builder: (FormFieldState<bool> state) {
            return CheckboxListTile(
              dense: true,
              title: title,
              value: state.value,
              onChanged: (value) {
                onChanged(value);
                state.didChange(value);
              },
              subtitle: state.hasError
                  ? Builder(
                      builder: (BuildContext context) => Text(
                        state.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    )
                  : null,
              controlAffinity: ListTileControlAffinity.leading,
            );
          },
        );
}
