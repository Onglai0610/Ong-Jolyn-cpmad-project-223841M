import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nomnomjourney_controller.dart';
import 'cusineInformation_page.dart';

class NomNomJourney extends StatelessWidget {
  const NomNomJourney({super.key});

  @override
  Widget build(BuildContext context) {
    final NomNomController controller = Get.put(NomNomController());
    final TextEditingController textController = TextEditingController();

    // Fetch saved restaurants when the page is built
    controller.fetchSavedRestaurants(); 

    return Scaffold(
      appBar: AppBar(
        title: const Text("My NOM NOM Journey"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F5F5), Color(0xFFFFE3BF)],
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Notes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            Obx(() {
              textController.text = controller.noteController.value;
              textController.selection = TextSelection.collapsed(offset: controller.noteController.value.length);
              return TextField(
                controller: textController,
                onChanged: controller.onNoteChanged,
                decoration: const InputDecoration(
                  hintText: "e.g. I'm craving for chicken rice, I got to eat it tomorrow",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 3,
                style: const TextStyle(fontSize: 15),
              );
            }),

            Obx(() => controller.showSaveButton.value
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: controller.saveNote,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Save"),
                      ),
                    ),
                  )
                : const SizedBox()),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Saved", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => Get.toNamed('/search', arguments: {'fromNomNomJourney': true}),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Obx(() => controller.savedRestaurants.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Divider(color: Colors.black, thickness: 0.5),
                          const Text("Your saved list is empty"),
                          const Divider(color: Colors.black, thickness: 0.5),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Get.toNamed('/search', arguments: {'fromNomNomJourney': true}),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              textStyle: const TextStyle(fontSize: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            ),
                            child: const Text("Explore cuisines", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.savedRestaurants.length,
                      itemBuilder: (context, index) {
                        var restaurant = controller.savedRestaurants[index];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            onTap: () => Get.to(() => CuisineInformationPage(
                              fromNomNomJourney: true,
                              restaurantId: restaurant['restaurantId'],
                              restaurantName: restaurant['restaurantName'],
                              cuisine: restaurant['cusineName'],
                              description: restaurant['description'],
                              rating: restaurant['rating'],
                              rewards: restaurant['rewards'],
                              imageUrl: restaurant['imageUrl'],
                              outletAddresses: restaurant['outletAddresses'],
                            )),
                            leading: restaurant['imageUrl'] != null && restaurant['imageUrl'].isNotEmpty
                                ? Image.network(
                                    restaurant['imageUrl'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
                                  )
                                : const Icon(Icons.image, size: 50),
                            title: Text(restaurant['restaurantName'] ?? 'Unknown'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(restaurant['cusineName'] ?? 'No cuisine info'),
                                Text("Rating: ${restaurant['rating']}")
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.removeSavedRestaurant(restaurant['restaurantId']),
                            ),
                          ),
                        );
                      },
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
