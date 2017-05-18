// In Nomine character generator
// Dart 1.22.1

//
// Imports
//
import 'dart:math';
import 'dart:mirrors';

//
// Initialize global variables
//

var rng = new Random();

String lb = "\n";
String tb = "\t";

List realmlist = ["Corporeal", "Ethereal", "Celestial"];

Map types = {
              "angel":{
                "cb":["Seraph","Cherub","Ofanite","Elohite","Malakite","Kyriotate","Mercurian"],
                "words":["Dreams","Children","Stone","Judgment","Creation","Fire","the Wind","Lightning","Animals","Faith","the Sword","Revelation","Trade","War","Flowers","Destiny","Protection"]
              }, "demon":{
                "cb":["Balseraph","Djinn","Calabite","Habbalite","Lilim","Shedite","Impudite"],
                "words":["Nightmares","Lust","the Game","the War","Fire","Drugs","Hardcore","Secrets (shhh!)","Gluttony","Dark Humor","Fate","Freedom","Factions","the Media","Death","Theft","Technology"]
              }
            };

Map skillslist = {"Corporeal": ["Acrobatics","Climbing","Dodge","Escape","Fighting","Large Weapon","Move Silently","Running","Swimming","Throwing"],
                  "Ethereal": ["Knowledge","Knowledge","Knowledge","Area Knowledge","Area Knowledge","Area Knowledge","Chemistry","Computer Operation","Driving","Electronics","Engineering","Language","Lockpicking","Lying","Medicine","Ranged Weapon","Savoir-Faire","Small Weapon","Tactics"],
                  "Celestial": ["Artistry","Detect Lies","Emote","Fast-Talk","Seduction","Singing","Survival","Tracking"]};

List aklist = ["Heaven","Hell","Marches","Caribbean","New York","New England","Florida","Atlanta","Texas","California","American Southwest","Pacific Northwest","Portland","Toronto","Vancouver","Mexico","Central America","Brazil","Argentina","England","London","France","Paris","Norway","Scandinavia","Greece","Egypt","North Africa","Sub-Saharan Africa","Saudi Arabia","Middle East","Russia","Moscow","China","Shanghai","Hong Kong","Japan","Hokkaido","Tokyo","Australia","Sydney","Melbourne","Perth","Fiji","Antarctica"];
List knowlist = ["Astronomy","Biology","Literature","Aircraft","American Football","Football","Baseball","Sumo","Giant Robot Anime","German Cuisine","Catholicism","Islam","Buddhism","Shinto","Architecture","Eschatology","Numinology","Role-Playing Games","Spelunking","Parliamentary Procedure","Olympic History","18th-Century Botanical Manuals","Photography","Marine Biology","Entomology","Archaeology"];
List langlist = ["Mandarin","Spanish","English","Hindi","Arabic","Portuguese","Bengali","Russian","Japanese","Punjabi","German","Javanese","Wu","Malay","Telugu","Vietnamese","Korean","French","Marathi","Tamil","Urdu","Turkish","Italian","Yue (Cantonese)", "Thai", "Latin", "Greek", "Ancient Egyptian", "Apache", "Ainu", "Aleut", "Inuit", "Mayan"];

//
// Global functions
//

// Returns a random element from the supplied array
List getRand(List ary) {
  //var aryrng = new Random();
  return ary[rng.nextInt(ary.length)];
}

// Parses command-line arguments
void parseArgs(List args) {

}

// Error abstraction
void argError(String err_text) {
  throw new ArgumentError("Argument error: $err_text");
}

// Generates a random name between 5 and 9 characters long
// Picks randomly between a vowel and a consonant to start, then
// alternates vowels with consonants
String rName() {
  var vowels = ["a","e","i","o","u","w","y"];
  var consonants = ["b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","z"];
  var ln = rng.nextInt(5) + 4;
  var nm = "";
  var toggle = rng.nextInt(2) == 1 ? true : false;
  for (var i = 0; i < ln; i++) {
    if (toggle) {
      nm += getRand(consonants);
    } else {
      nm += getRand(vowels);
    }
    toggle = !toggle;
  }
  return nm.replaceRange(0,1,nm[0].toUpperCase());
}

//
// Define Character class
//

class Character {

  String name;
  String cb;
  String word;
  Map forces = {"Corporeal": 1, "Ethereal": 1, "Celestial": 1};
  Map attributes = {"Corporeal": [1,1], "Ethereal": [1,1], "Celestial": [1,1]};
  Map skills = {};
  List attunements = [];
  num fcs = 6;
  num maxcp;
  num spent = 0;

  Character() {
    //var rng = new Random();
    String typ = getRand(["angel","demon"]);
    maxcp = (fcs + 3) * 4;
    name = rName();
    cb = getRand(types[typ]["cb"]);
    word = getRand(types[typ]["words"]);
    attunements.add("${cb} of ${word}"); // Everyone gets this for free
    skills["Language (Local)"] = 3; // Everyone gets this for free
    List sklselect = [];
    var i = 0;
    while (i < fcs) {
      i += addForce() ? 1 : 0; // Add a Force to a random realm if Forces in that realm aren't already 6
    }
    realmlist.forEach( (rlm) {
      for (var j = 0; j < (forces[rlm] * 4) - 2; j++) {
        addChar(rlm); // Add a point to one of the characteristics in each realm, max 12
      }
      for (var j = 0; j < forces[rlm]; j++) {
        sklselect.add(rlm); // List of realms weighted by number of Forces
      }
    });
    // Number of character points available is roughly 2/3 the total allotment
    // The generator can go over since it doesn't track until after spending, but not by much
    num skilldelta = (maxcp*0.33).floor() - 1;
    num skillpoints = maxcp - (skilldelta + rng.nextInt((skilldelta*1.25).floor() - skilldelta));
    while (spent < skillpoints) {
      num styp = rng.nextInt(15);
      if (styp < 8) { // 0-8 assigns a skill
        // Skills
        // Use the weighted list of realms to select skills
        // This helps ensure skills tend to be usable by the character
        String newskl = getRand(skillslist[getRand(sklselect)]);
        // Seraphim and Balseraphs can't have Lying
        if ((cb == "Seraph" || cb == "Balseraph") && newskl == "Lying") {
          continue;
        }
        // Assign specializations
        if (newskl == "Knowledge") {
          newskl += " (" + getRand(knowlist) + ")";
        } else if (newskl == "Area Knowledge") {
          newskl += " (" + getRand(aklist) + ")";
        } else if (newskl == "Language") {
          newskl += " (" + getRand(langlist) + ")";
        }
        if (skills.containsKey(newskl)) { // If the skill is already there
          if (skills[newskl] < 6) {       // And it's under the maximum
            skills[newskl] += 1;          // Add 1 to it
            spent += 1;
          }
        } else {                          // Otherwise, set it to 1-3
          num amt = rng.nextInt(3) + 1;
          skills[newskl] = amt;
          spent += amt;
        }
        // Spend CP only if the skill was actually assigned
      } else if (styp < 14) { // 9-13 assigns a Song
        // Songs - not implemented yet
      } else { // 14 assigns an attunement
        // Attunements
        num atyp = rng.nextInt(3);
        String newattn = "";
        String nacb;
        String naword;
        do {
          if (atyp < 2) {
            // Same superior, different choir/band
            nacb = getRand(types[typ]["cb"]);
            naword = word;
          } else {
            // Same choir/band, different superior
            naword = getRand(types[typ]["words"]);
            nacb = cb;
          }
          newattn = "$nacb of $naword";
        } while (attunements.contains(newattn)); // make sure we don't add the same attunement twice
        attunements.add(newattn);
        spent += 5;
      }
    }

  }

  bool addForce([String realm]) {
    String realm;
    if (!realm) {
      realm = getRand(realmlist);
    }
    if (forces[realm] == 6) {
      return false;
    } else {
      forces[realm] += 1;
      return true;
    }
  }

  void addChar(String realm) {
    //var rnd = new Random();
    num wc = rng.nextInt(2);
    if (attributes[realm][wc] == 12) {
      attributes[realm][1-wc] += 1;
    } else {
      attributes[realm][wc] += 1;
    }
  }

// If prt is True, print the output before returning it
  String output([bool prt]) {
    String out = "";
    out += "$name";
    out += "$lb$cb of $word";
    out += "$lb${forces['Corporeal']} Corporeal$tb${forces['Ethereal']} Ethereal$tb${forces['Celestial']} Celestial";
    out += "$lb${attributes['Corporeal'][0]} Strength$tb${attributes['Ethereal'][0]} Intellect$tb${attributes['Celestial'][0]} Will";
    out += "$lb${attributes['Corporeal'][1]} Agility$tb${attributes['Ethereal'][1]} Precision$tb${attributes['Celestial'][1]} Perception";
    out += "$lb${lb}Skills: ";
    List skls = skills.keys;
    List sklslist = [];
    skls.forEach( (el) => sklslist.add("$el/${skills[el]}") );
    sklslist.sort();
    out += sklslist.join(", ");
    out += "${lb}Attunements: " + attunements.join(", ");
    out += "$lb$lb${maxcp-spent} character points remaining";
    if (prt) { print(out); }
    return out;
  }

}

//
// Main function
// It accepts a list of strings as arguments,
// which are space-separated on the command line
//

void main(List<String> args) {
  parseArgs(args);
  var chr = new Character();
  chr.output(true);
}
