import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medmap/route/app_routes.dart';
import 'request_cubit.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _totalEmployeesController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  int? _selectedCountryId;
  int? _selectedStateId;

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    context.go(AppRoutes.home);
    return true;
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    _companyController.dispose();
    _totalEmployeesController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Partnership'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go(AppRoutes.home); // Redirect to home
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        // create: (context) => RequestCubit(),
        create: (context) {
          final getData = RequestCubit();
          getData.fetchCountries();
          return getData;
        },
        child: BlocConsumer<RequestCubit, RequestState>(
          listener: (context, state) {
            if (state is RequestSuccess) {
              context.go(AppRoutes.home);
            } else if (state is RequestFailure) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(state.errorMessage),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            final logo = Hero(
              tag: 'logo',
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 48.0,
                child: Image.asset('assets/icons/handshake.png'),
              ),
            );

            final loginButton = Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5.0,
                  side: BorderSide.none,
                  padding: EdgeInsets.all(12.0),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final formData = {
                      'total_employee': _totalEmployeesController.text,
                      'company_name': _companyController.text,
                      'first_name': _firstNameController.text,
                      'last_name': _lastNameController.text,
                      'email': _emailController.text,
                      'phone': _phoneController.text,
                      'country_id': _selectedCountryId.toString(),
                      'state_id': _selectedStateId.toString(),
                      'zip_code': _zipCodeController.text
                    };
                    context.read<RequestCubit>().submitForm(formData);
                  }
                },
                child: Text('SUBMIT', style: TextStyle(fontSize: 18)),
              ),
            );
            return Center(
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    if (state is RequestLoading)
                      CircularProgressIndicator()
                    else
                      logo,
                    SizedBox(height: 48.0),
                    TextFormField(
                      controller: _companyController,
                      decoration: InputDecoration(labelText: 'Company Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a company name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _totalEmployeesController,
                      decoration: InputDecoration(labelText: 'Total Employees'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter total employees';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(labelText: 'First Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(labelText: 'Last Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.0),
                    if (state is CountriesLoaded)
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(labelText: 'Country'),
                        value: context.select(
                            (RequestCubit cubit) => cubit.selectedCountryId),
                        items: state.countries.map((country) {
                          return DropdownMenuItem<int>(
                            value: country.id,
                            child: Text(country.name),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          context
                              .read<RequestCubit>()
                              .setSelectedCountryId(newValue);
                          context.read<RequestCubit>().fetchStates(newValue!);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a country';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 8.0),
                    if (state is StatesLoaded)
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(labelText: 'State'),
                        value: context.select(
                            (RequestCubit cubit) => cubit.selectedStateId),
                        items: state.states.map((state) {
                          return DropdownMenuItem<int>(
                            value: state.id,
                            child: Text(state.name),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          context
                              .read<RequestCubit>()
                              .setSelectedStateId(newValue);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a state';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _zipCodeController,
                      decoration: InputDecoration(labelText: 'Zip Code'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter zip code';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.0),
                    loginButton,
                    SizedBox(height: 24.0),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
