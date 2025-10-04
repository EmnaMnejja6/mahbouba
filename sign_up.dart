import 'package:agriwie/screens/Assistantchoice_page.dart';
import 'package:flutter/material.dart';
import '../main_navigation.dart';
import 'home_page.dart';
import 'login_page.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E7D32),
              Color(0xFF43A047),
              Color(0xFF66BB6A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(height: 40),

                  // Welcome header
                  _buildWelcomeHeader(),
                  SizedBox(height: 40),

                  // Sign up form
                  SlideTransition(
                    position: _slideAnimation,
                    child: _buildSignUpForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Text("👩‍🌾", style: TextStyle(fontSize: 60)),
        ),
        Text(
          "مرحباً بك في رحلة التغيير",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "أنشئي حسابك الآن",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),

            // Name field
            _buildTextFormField(
              controller: _nameController,
              label: "الاسم الكامل",
              hint: "مثال: فاطمة أحمد",
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "يرجى إدخال الاسم";
                }
                if (value.length < 2) {
                  return "الاسم قصير جداً";
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Age field
            _buildTextFormField(
              controller: _ageController,
              label: "العمر",
              hint: "مثال: 35",
              icon: Icons.cake,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "يرجى إدخال العمر";
                }
                final age = int.tryParse(value);
                if (age == null || age < 18 || age > 80) {
                  return "يرجى إدخال عمر صحيح (18-80)";
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Password field
            _buildTextFormField(
              controller: _passwordController,
              label: "كلمة المرور",
              hint: "اختاري كلمة مرور قوية",
              icon: Icons.lock,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "يرجى إدخال كلمة المرور";
                }
                if (value.length < 6) {
                  return "كلمة المرور قصيرة جداً (أقل من 6 أحرف)";
                }
                return null;
              },
            ),
            SizedBox(height: 24),


            SizedBox(height: 24),

            // Sign up button
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E7D32),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  : Text(
                "ابدئي رحلة النجاح",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    "سجلي الدخول",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                        decoration: TextDecoration.underline
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 10,),
                Text(
                  " لديك حساب ؟",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        SizedBox(height: 40,
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && !_isPasswordVisible,
            keyboardType: keyboardType,
            validator: validator,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(icon, color: Color(0xFF43A047)),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Color(0xFF43A047),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
                  : null,
              filled: true,
              fillColor: Color(0xFFF8F9FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF43A047), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        )],
    );
  }

  void _handleSignUp() async {
    setState(() {
      _isLoading = true;});
    /* if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
*/
    // Simulate API call
    /*  await Future.delayed(Duration(seconds: 2)); */



    // Show success and navigate to home
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("مرحباً بك ${_nameController.text}! مرحباً بك في رحلة النجاح"),
        backgroundColor: Color(0xFF43A047),
        duration: Duration(seconds: 3),
      ),
    );

    setState(() {
      _isLoading = false;
    });

    // Navigate to home screen
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigationScreen()));
  }
}