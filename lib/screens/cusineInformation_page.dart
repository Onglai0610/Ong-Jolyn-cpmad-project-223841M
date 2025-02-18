import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'map_page.dart';

class CuisineInformationPage extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final String cuisine;
  final String description;
  final double rating;
  final String rewards;
  final String imageUrl;
  final List<String> outletAddresses;
  final bool fromNomNomJourney;

  const CuisineInformationPage({
    Key? key,
    required this.restaurantId,
    required this.restaurantName,
    required this.cuisine,
    required this.description,
    required this.rating,
    required this.rewards,
    required this.imageUrl,
    required this.outletAddresses,
    this.fromNomNomJourney = false,
  }) : super(key: key);

  @override
  _CuisineInformationPageState createState() => _CuisineInformationPageState();
}

class _CuisineInformationPageState extends State<CuisineInformationPage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  void _viewOnMap() async {
    setState(() {
      _isLoading = true;
    });

    final outlets = await _firestoreService.getOutletData(widget.restaurantId);

    setState(() {
      _isLoading = false;
    });

    if (outlets.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(
            restaurantId: widget.restaurantId,
            outlets: outlets,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No outlets found for this restaurant.")),
      );
    }
  }

  void _saveToNomNomJourney() {
    _firestoreService.saveToNomNomJourney(
      context: context,
      restaurantId: widget.restaurantId,
      restaurantName: widget.restaurantName,
      cuisine: widget.cuisine,
      description: widget.description,
      rating: widget.rating,
      rewards: widget.rewards,
      imageUrl: widget.imageUrl,
      outletAddresses: widget.outletAddresses,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.restaurantName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text("${widget.rating}/5"),
                      const Icon(Icons.star, color: Colors.yellow),
                    ],
                  ),
                ],
              ),
              Text(widget.cuisine, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              Text("Why Visit?", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(widget.description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Outlets:", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _viewOnMap,
                    child: _isLoading 
                        ? const SizedBox(
                            height: 20, 
                            width: 20, 
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("View in Map"),
                  ),
                ],
              ),

              if (widget.outletAddresses.isNotEmpty)
                ...widget.outletAddresses.map((address) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text("- $address", style: const TextStyle(fontSize: 16)),
                    )),
              if (widget.outletAddresses.isEmpty)
                const Text("No outlet information available", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),

              const SizedBox(height: 20),

              if (widget.rewards.isNotEmpty) ...[
                Text("Limited Time Rewards", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(widget.rewards, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 20),
              ],

              if (!widget.fromNomNomJourney)
                Center(
                  child: ElevatedButton(
                    onPressed: _saveToNomNomJourney,
                    child: const Text("Save this to your NOM NOM Journey"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
