import 'dart:async';
import 'package:assignment12_6509966_ict425/Screens/EmployeePage.dart';
import 'package:assignment12_6509966_ict425/Screens/LocationPage.dart';
import 'package:assignment12_6509966_ict425/Screens/LoginPage.dart';
import 'package:assignment12_6509966_ict425/Screens/WeatherServicePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WeatherPageState();
  }
}

class _WeatherPageState extends State<WeatherPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Timer _timer;
  String _currentTime = DateFormat.Hms().format(DateTime.now());

  Map<String, dynamic>? _weatherData;
  Map<String, dynamic>? _airData;
  String _unit = 'metric';
  String _location = 'Loading...';
  String fullName = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _startClock();
    _loadData();
    _loadFullName();
  }

  Future<void> _loadFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? 'Unknown';
    });
  }

  void _startClock() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _currentTime = DateFormat.Hms().format(DateTime.now());
      });
    });
  }

  Future<void> _loadData() async {
    final locationPage = LocationPage(title: 'Location',);
    final coords = await locationPage.getLocation();

    if (coords != null) {
      final lat = coords['latitude']!;
      final lon = coords['longitude']!;

      final weatherService = WeatherService();
      final weather = await weatherService.getWeatherByCoordinates(lat, lon, _unit);
      final air = await weatherService.getAirPollution(lat, lon);
      final city = await weatherService.getCityName(lat, lon);

      setState(() {
        _weatherData = weather;
        _airData = air;
        _location = city;
      });
    }
  }

  void _changeUnit(String selectedUnit) {
    setState(() {
      _unit = selectedUnit;
      _weatherData = null;
    });
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: PopupMenuButton<String>(
              onSelected: _changeUnit,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'metric', child: Text('Celsius')),
                PopupMenuItem(value: 'imperial', child: Text('Fahrenheit')),
              ],
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.business_center), text: 'Current Weather'),
            Tab(icon: Icon(Icons.help_center), text: 'Air Pollution'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.purpleAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Image.asset("assets/images/RSU_Logo.png", height: 60),
                  const SizedBox(height: 10),
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Employees'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const EmployeePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud),
              title: const Text('Weather'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Exit'),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCurrentWeatherTab(),
          _buildAirPollutionTab(),
        ],
      ),
    );
  }

  Widget _buildCurrentWeatherTab() {
    if (_weatherData == null) {
      return Center(child: CircularProgressIndicator());
    }

    final temp = _weatherData!['main']['temp'];
    final description = _weatherData!['weather'][0]['description'];
    final maxTemp = _weatherData!['main']['temp_max'];
    final minTemp = _weatherData!['main']['temp_min'];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.lightBlueAccent.shade100,
            Colors.purpleAccent.shade100
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            _location,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 8),
          Text(
            DateFormat.yMMMMd().format(DateTime.now()),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 8),
          Text(
            _currentTime,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 30),

          //CLoud Design
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            // getWeatherIcon(temp, _unit == 'metric' ? 'C' : 'F'),
                            // 'assets/icons/cloud.png',
                            getWeatherIcon(description),
                            width: 150,
                            height: 150,
                          ),
                          SizedBox(width: 50),
                          Text(
                            '${temp.toStringAsFixed(1)} ${_unit == 'metric' ?  '°C' : '°F'}',
                            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      '${description[0].toUpperCase()}${description.substring(1)}',
                      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                         Image.asset(
                           'assets/icons/high_temperature.png',
                           width: 30,
                           height: 30,
                         ),
                          Text(
                            ' Max: ${maxTemp.toStringAsFixed(1)} ${_unit == 'metric' ? '°C' : '°F'}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/low_temperature.png',
                            width: 30,
                            height: 30,
                          ),
                          Text(
                            ' Min: ${minTemp.toStringAsFixed(1)} ${_unit == 'metric' ? '°C' : '°F'}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 80),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getWeatherIcon(String description) {
    description = description.toLowerCase();

    if (description.contains('cloud')) {
      return 'assets/icons/cloud.png';
    } else if (description.contains('rain') || description.contains('drizzle')) {
      return 'assets/icons/raining.png';
    } else if (description.contains('night')) {
      return 'assets/icons/night.png';
    } else if (description.contains('mist') || description.contains('fog') || description.contains('haze')) {
      return 'assets/icons/mist.png';
    } else if (description.contains('clear') || description.contains('sunny')) {
      return 'assets/icons/sun.png';
    } else if (description.contains('humidity')) {
      return 'assets/icons/humidity.png';
    } else {
      return 'assets/icons/cloud.png'; // default
    }
  }

  Widget _buildAirPollutionTab() {
    if (_airData == null) {
      return Center(child: CircularProgressIndicator());
    }

    final components = _airData!['list'][0]['components'];
    final aqi = _airData!['list'][0]['main']['aqi'];
    final co = components['co'];
    final o3 = components['o3'];
    final pm25 = components['pm2_5'];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.purple.shade100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            _location,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 20),
          Text(
            DateFormat.yMMMMd().format(DateTime.now()),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          _buildPollutionTile('AQI', aqi.toDouble(), _getColorForAqi(aqi)),
          _buildPollutionTile('CO', co, _getColorForCO(co)),
          _buildPollutionTile('O3', o3, _getColorForO3(o3)),
          _buildPollutionTile('PM 2.5', pm25, _getColorForPM25(pm25)),
        ],
      ),
    );
  }

  Widget _buildPollutionTile(String label, double value, Color color) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Center(
            child: Text(
              '${value.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForAqi(int aqi) {
    switch (aqi) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getColorForCO(double co) {
    if (co < 4400)
      return Colors.green;
    else if (co < 9400)
      return Colors.yellow;
    else if (co < 12400)
      return Colors.orange;
    else if (co < 15400)
      return Colors.red;
    else
      return Colors.purple;
  }

  Color _getColorForO3(double o3) {
    if (o3 < 60)
      return Colors.green;
    else if (o3 < 100)
      return Colors.yellow;
    else if (o3 < 140)
      return Colors.orange;
    else if (o3 < 180)
      return Colors.red;
    else
      return Colors.purple;
  }

  Color _getColorForPM25(double pm) {
    if (pm < 10)
      return Colors.green;
    else if (pm < 25)
      return Colors.yellow;
    else if (pm < 50)
      return Colors.orange;
    else if (pm < 75)
      return Colors.red;
    else
      return Colors.purple;
  }
}
