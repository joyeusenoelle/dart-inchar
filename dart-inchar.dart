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
  var aryrng = new Random();
  return ary[aryrng.nextInt(ary.length)];
}

// Parses command-line arguments
void parseArgs(List args) {

}

// Error abstraction
void argError(String err_text) {
  throw new ArgumentError("Argument error: $err_text");
}

//
// Define Character class
//

class Character {

  String cb;
  String word;
  Map forces = {"Corporeal": 1, "Ethereal": 1, "Celestial": 1};
  Map attributes = {"Corporeal": [1,1], "Ethereal": [1,1], "Celestial": [1,1]};
  Map skills = {};
  List attunements = [];
  num fcs = 6;
  num maxcp;
  num cp;
  num spent = 0;

  Character() {
    var rng = new Random();
    String typ = getRand(["angel","demon"]);
    maxcp = (fcs + 3) * 4;
    cp = maxcp;
    cb = getRand(types[typ]["cb"]);
    word = getRand(types[typ]["words"]);
    attunements.add("${cb} of ${word}");
    var i = 0;
    while (i < fcs) {
      i += addForce() ? 1 : 0;
    }
    realmlist.forEach( (el) {
      for (var j = 0; j < (forces[el] * 4) - 2; j++) {
        addChar(el);
      }
    });
    num skilldelta = (cp*0.33).floor() - 1;
    num skillpoints = cp - (skilldelta + rng.nextInt((skilldelta*1.25).floor() - skilldelta));
    while (spent < skillpoints) {
      num styp = rng.nextInt(15);
      if (styp < 8) {
        // Skills
        
        spent += 1;
      } else if (styp < 12) {
        // Songs - not implemented yet
      } else {
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
        } while (attunements.contains(newattn));
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
    var rnd = new Random();
    num wc = rnd.nextInt(2);
    if (attributes[realm][wc] == 12) {
      attributes[realm][1-wc] += 1;
    } else {
      attributes[realm][wc] += 1;
    }
  }

// If prt is True, print the output before returning it
  String output([bool prt]) {
    String out = "";
    out += "$cb of $word";
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
    out += "$lb$lb${cp-spent} character points remaining";
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
