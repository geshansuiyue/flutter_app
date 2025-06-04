import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/user/user_api.dart';
import '../../http/request.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _capchaController = TextEditingController();
  bool _isLoading = false;
  bool _iscapchaBtnDisabled = true;
  bool _isLoginBtnDisabled = true;

  @override
  void initState() {
    super.initState();

    _phoneController.addListener(() {
      setState(() {
        _iscapchaBtnDisabled = _phoneController.text.length != 11 || _isLoading;
      });
    });

    _capchaController.addListener(() {
      setState(() {
        _isLoginBtnDisabled = _capchaController.text.length != 4 || _isLoading;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _capchaController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    if (_phoneController.text.isEmpty) {
      Fluttertoast.showToast(msg: '请输入手机号');
    }
    try {
      var response = Request.get(
        UserApi.getCaptcha,
        queryParameters: {'phone': _phoneController.text},
      );
      response.then((value) {
        if (value['code'] == 200) {
          Fluttertoast.showToast(msg: '验证码已发送');
        } else {
          Fluttertoast.showToast(msg: value['message'] ?? '获取验证码失败');
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: '获取验证码失败');
    }
  }

  Future<void> _userLogin() async {
    try {
      var response = await Request.get(
        UserApi.login,
        queryParameters: {
          'phone': _phoneController.text,
          'captcha': _capchaController.text,
        },
      );

      if (response['code'] == 200) {
        Fluttertoast.showToast(msg: '登录成功');
      } else {
        Fluttertoast.showToast(msg: response['message'] ?? '登录失败');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '登录失败，请稍后再试');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('用户登录')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: '手机号'),
                validator: (value) => value?.isEmpty ?? true ? '请输入手机号' : null,
                maxLength: 11,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      controller: _capchaController,
                      maxLength: 4,
                      decoration: const InputDecoration(labelText: '验证码'),
                      validator: (value) =>
                          value!.length < 4 ? '验证码至少4个字符' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: _iscapchaBtnDisabled
                          ? null
                          : _sendVerificationCode,
                      child: Text('获取验证码'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: _isLoginBtnDisabled ? null : _userLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('登录'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
