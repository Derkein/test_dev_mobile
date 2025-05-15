class FieldModel {
  final int id;
  final String label;
  final bool required;
  final String fieldType;

  FieldModel({
    required this.id,
    required this.label,
    required this.required,
    required this.fieldType,
  });

  factory FieldModel.fromJson(Map<String, dynamic> json) {
    return FieldModel(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      required: json['required'] ?? false,
      fieldType: json['field_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'required': required,
      'field_type': fieldType,
    };
  }
}