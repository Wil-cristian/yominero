class PostCreationValidator {
  static String? validateRequestBudget(String text) {
    if (text.trim().isEmpty) return null; // optional
    final v = double.tryParse(text.trim());
    if (v == null || v < 0) {
      return 'Presupuesto inválido (usa número positivo).';
    }
    return null;
  }

  static String? validateOfferPricing(String fromText, String toText) {
    final ft = fromText.trim();
    final tt = toText.trim();
    if (ft.isEmpty && tt.isEmpty) return null; // both optional
    final from = ft.isEmpty ? null : double.tryParse(ft);
    if (ft.isNotEmpty && (from == null || from < 0)) {
      return 'Valor "Desde" inválido (número positivo).';
    }
    final to = tt.isEmpty ? null : double.tryParse(tt);
    if (tt.isNotEmpty && (to == null || to < 0)) {
      return 'Valor "Hasta" inválido (número positivo).';
    }
    if (from != null && to != null && from > to) {
      return 'El rango de precios es inválido (Desde > Hasta).';
    }
    return null;
  }
}
