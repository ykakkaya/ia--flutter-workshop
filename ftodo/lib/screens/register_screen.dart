import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../core/theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/snackbars.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authProvider.notifier).register(
            name: _name.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
            passwordConfirmation: _confirm.text,
          );
      // Başarılı kayıtta auth state değişir; ekranı kapat, kök ekran yönlendirir.
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } catch (e) {
      if (mounted) showErrorSnack(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      title: 'Hesap Oluşturun',
      subtitle: 'Görevlerinizi düzenlemeye hemen başlayın',
      children: [
        Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
              AppTextField(
                controller: _name,
                label: 'Ad',
                maxLength: 255,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Ad gerekli' : null,
              ),
              AppTextField(
                controller: _email,
                label: 'E-posta adresi',
                hint: 'ornek@mail.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || !v.contains('@')) ? 'Geçerli e-posta girin' : null,
              ),
              AppTextField(
                controller: _password,
                label: 'Şifre (en az 8 karakter)',
                obscure: true,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.length < 8) ? 'En az 8 karakter' : null,
              ),
              AppTextField(
                controller: _confirm,
                label: 'Şifre tekrar',
                obscure: true,
                validator: (v) =>
                    v != _password.text ? 'Şifreler eşleşmiyor' : null,
              ),
              PrimaryButton(
                label: 'Kayıt Ol',
                loading: _loading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Zaten hesabınız var mı?',
                style: TextStyle(color: AppColors.onSurfaceVariant)),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Giriş Yap',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }
}
