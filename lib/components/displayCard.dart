import 'package:campusdiningapp_mobile/model/meal_mdl.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart'; 

class DisplayCard extends StatelessWidget {
  final Item item;
  const DisplayCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        //! Front Card
        front: Card(
          elevation: 4.0,
          color: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 250.0,
            alignment: Alignment.center,
            child: Stack(
              children: [
                item.photoUrl.isNotEmpty
                    ? Positioned.fill(
                        child: Image.network(
                          item.photoUrl,
                          fit: BoxFit.cover, 
                        ),
                      )
                    : const Positioned.fill(
                        child: Icon(Icons.image,
                            size: 120), 
                      ),
                // Overlay text
                Positioned(
                  bottom: 110,
                  left: 10,
                  right: 10,
                  child: Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                      backgroundColor:
                          Colors.black54, 
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //todo: Back card
        back: Card(
          elevation: 4.0,
          color: const Color.fromARGB(255, 255, 255, 255), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 250.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Description
                Center(
                  child: Text(
                    'Description: ${item.description}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Price
                Text(
                  'Price: \$${item.price}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Created on: ${item.dateCreated.toLocal()}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(179, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}