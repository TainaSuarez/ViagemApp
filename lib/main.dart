import 'package:custoviagem/FuelPrice.dart';
import 'package:custoviagem/Car.dart';
import 'package:custoviagem/Destination.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Costo de Viaje',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  List<Car> cars = [];
  List<Destination> destinations = [];
  List<FuelPrice> fuelPrices = [];

  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carAutonomyController = TextEditingController();
  final TextEditingController destinationNameController = TextEditingController();
  final TextEditingController destinationDistanceController = TextEditingController();
  final TextEditingController fuelPriceController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro de Datos")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Registrar Carro:", style: TextStyle(fontSize: 20)),
              TextField(
                controller: carNameController,
                decoration: InputDecoration(labelText: "Nombre del carro"),
              ),
              TextField(
                controller: carAutonomyController,
                decoration: InputDecoration(labelText: "Autonomía (km por litro)"),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onPressed: () {
                  String carName = carNameController.text;
                  double autonomy = double.parse(carAutonomyController.text);
                  setState(() {
                    cars.add(Car(name: carName, autonomy: autonomy));
                  });
                  carNameController.clear();
                  carAutonomyController.clear();
                },
                child: Text("Registrar Carro"),
              ),
              SizedBox(height: 20),
              Text("Registrar Destino:", style: TextStyle(fontSize: 20)),
              TextField(
                controller: destinationNameController,
                decoration: InputDecoration(labelText: "Nombre del destino"),
              ),
              TextField(
                controller: destinationDistanceController,
                decoration: InputDecoration(labelText: "Distancia (km)"),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onPressed: () {
                  String destinationName = destinationNameController.text;
                  double distance = double.parse(destinationDistanceController.text);
                  setState(() {
                    destinations.add(Destination(name: destinationName, distance: distance));
                  });
                  destinationNameController.clear();
                  destinationDistanceController.clear();
                },
                child: Text("Registrar Destino"),
              ),
              SizedBox(height: 20),
              Text("Registrar Precio de Combustible:", style: TextStyle(fontSize: 20)),
              TextField(
                controller: fuelTypeController,
                decoration: InputDecoration(labelText: "Tipo de combustible"),
              ),
              TextField(
                controller: fuelPriceController,
                decoration: InputDecoration(labelText: "Precio por litro"),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onPressed: () {
                  String fuelType = fuelTypeController.text;
                  double pricePerLiter = double.parse(fuelPriceController.text);
                  setState(() {
                    fuelPrices.add(FuelPrice(
                      pricePerLiter: pricePerLiter,
                      fuelType: fuelType,
                      date: DateTime.now(),
                    ));
                  });
                  fuelTypeController.clear();
                  fuelPriceController.clear();
                },
                child: Text("Registrar Precio"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalculationScreen(cars: cars, destinations: destinations, fuelPrices: fuelPrices)),
                  );
                },
                child: Text("Ir a Calcular Costo de Viaje"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalculationScreen extends StatefulWidget {
  final List<Car> cars;
  final List<Destination> destinations;
  final List<FuelPrice> fuelPrices;

  CalculationScreen({required this.cars, required this.destinations, required this.fuelPrices});

  @override
  _CalculationScreenState createState() => _CalculationScreenState();
}

class _CalculationScreenState extends State<CalculationScreen> {
  Car? selectedCar;
  Destination? selectedDestination;
  FuelPrice? selectedFuelPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calcular Costo de Viaje")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<Car>(
                hint: Text("Selecciona un carro"),
                value: selectedCar,
                onChanged: (Car? newValue) {
                  setState(() {
                    selectedCar = newValue;
                  });
                },
                items: widget.cars.map((Car car) {
                  return DropdownMenuItem<Car>(
                    value: car,
                    child: Text("${car.name} (Autonomía: ${car.autonomy} km/L)"),
                  );
                }).toList(),
              ),
              DropdownButton<Destination>(
                hint: Text("Selecciona un destino"),
                value: selectedDestination,
                onChanged: (Destination? newValue) {
                  setState(() {
                    selectedDestination = newValue;
                  });
                },
                items: widget.destinations.map((Destination destination) {
                  return DropdownMenuItem<Destination>(
                    value: destination,
                    child: Text("${destination.name} (Distancia: ${destination.distance} km)"),
                  );
                }).toList(),
              ),
              DropdownButton<FuelPrice>(
                hint: Text("Selecciona el precio del combustible"),
                value: selectedFuelPrice,
                onChanged: (FuelPrice? newValue) {
                  setState(() {
                    selectedFuelPrice = newValue;
                  });
                },
                items: widget.fuelPrices.map((FuelPrice fuelPrice) {
                  return DropdownMenuItem<FuelPrice>(
                    value: fuelPrice,
                    child: Text("${fuelPrice.fuelType} (\$${fuelPrice.pricePerLiter}/L) - ${fuelPrice.date.toLocal()}"),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onPressed: () {
                  if (selectedCar != null && selectedDestination != null && selectedFuelPrice != null) {
                    double cost = calculateTripCost(
                      selectedCar!,
                      selectedDestination!,
                      selectedFuelPrice!,
                    );

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Costo del viaje"),
                        content: Text("El costo del viaje es: \$${cost.toStringAsFixed(2)}"),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Error"),
                        content: Text("Por favor selecciona un carro, destino y precio de combustible"),
                      ),
                    );
                  }
                },
                child: Text("Calcular Costo del Viaje"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateTripCost(Car car, Destination destination, FuelPrice fuelPrice) {
    double litersNeeded = destination.distance / car.autonomy; // Litros necesarios
    double cost = litersNeeded * fuelPrice.pricePerLiter; // Costo total
    return cost;
  }
}
