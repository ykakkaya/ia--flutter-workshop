import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../core/theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/snackbars.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .login(_email.text.trim(), _password.text);
    } catch (e) {
      if (mounted) showErrorSnack(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      title: 'Tekrar Hoşgeldiniz',
      subtitle: 'Görevlerinizi yönetmek için giriş yapın',
      children: [
        Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
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
                label: 'Şifre',
                hint: '••••••••',
                obscure: true,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Şifre gerekli' : null,
              ),
              PrimaryButton(
                label: 'Giriş Yap',
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
            const Text('Hesabınız yok mu?',
                style: TextStyle(color: AppColors.onSurfaceVariant)),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              ),
              child: const Text('Kayıt Ol',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }
}
