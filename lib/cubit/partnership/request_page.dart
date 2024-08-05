import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medmap/route/app_routes.dart';
import 'request_cubit.dart';
import 'request_state.dart';

class RequestPage extends StatefulWidget {
  final int itemId;
  RequestPage({required this.itemId});
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

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    context.go('/home'); // Use your correct home route here
    return true;
  }

  @override
  void initState() {
    super.initState();
    // BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    // BackButtonInterceptor.remove(myInterceptor);
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
            context.go(AppRoutes.home);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) {
          final cubit = RequestCubit();
          cubit.fetchCountries();
          return cubit;
        },
        child: BlocConsumer<RequestCubit, RequestState>(
          listener: (context, state) {
            if (state is RequestError) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(state.message),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (state is RequestSuccess) {
              context.go('/home');
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

            final submitButton = Padding(
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
                      'country_id':
                          context.read<RequestCubit>().selectedCountryId,
                      'state_id': context.read<RequestCubit>().selectedStateId,
                      'zip_code': _zipCodeController.text
                    };
                    context
                        .read<RequestCubit>()
                        .submitForm(context, widget.itemId, formData);
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
                    if (state is RequestLoading &&
                        !(state is CountriesLoaded || state is StatesLoaded))
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
                    CountryDropdown(),
// if (context.read<RequestCubit>().selectedCountryId != null)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Text(
//                           context.read<RequestCubit>().getSelectedCountryName(),
//                           style: TextStyle(fontSize: 16, color: Colors.red),
//                         ),
//                       ),
                    SizedBox(height: 8.0),
                    StateDropdown(),
                    // if (context.read<RequestCubit>().selectedStateId != null)
                    //   Padding(
                    //     padding: const EdgeInsets.only(top: 8.0),
                    //     child: Text(
                    //       context.read<RequestCubit>().getSelectedStateName(),
                    //       style: TextStyle(fontSize: 16),
                    //     ),
                    //   ),
                    SizedBox(height: 24.0),
                    submitButton,
                    SizedBox(height: 8.0),
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

class CountryDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestCubit, RequestState>(
      builder: (context, state) {
        if (state is CountriesLoaded) {
          return DropdownButtonFormField<String>(
            value: context.read<RequestCubit>().selectedCountryId,
            decoration: InputDecoration(labelText: 'Country'),
            items: state.countries.map<DropdownMenuItem<String>>((country) {
              return DropdownMenuItem<String>(
                value: country['id'].toString(),
                child: Text(country['name']),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                print('Selected Country ID: $value');
                context.read<RequestCubit>().selectCountry(value);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a country';
              }
              return null;
            },
          );
        } else if (state is RequestLoading) {
          return CircularProgressIndicator();
        } else {
          return Container();
        }
      },
    );
  }
}

class StateDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestCubit, RequestState>(
      builder: (context, state) {
        if (state is StatesLoaded) {
          return DropdownButtonFormField<String>(
            value: context.read<RequestCubit>().selectedStateId,
            decoration: InputDecoration(labelText: 'State'),
            items: state.states.map<DropdownMenuItem<String>>((state) {
              return DropdownMenuItem<String>(
                value: state['id'].toString(),
                child: Text(state['name']),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                print('Selected State ID: $value');
                context.read<RequestCubit>().selectState(value);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a state';
              }
              return null;
            },
          );
        } else if (state is RequestLoading) {
          return CircularProgressIndicator();
        } else {
          return Container();
        }
      },
    );
  }
}
