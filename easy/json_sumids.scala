/*
Created by Yamato Matsuoka on 2013-07-08

Challenge Description
-----------------------
You have JSON string which describes a menu. Calculate the SUM of IDs of all "items" in case a "label" exists for an item.

Input sample
-------------
Your program should accept as its first argument a path to a filename. Input example is the following
```
{"menu": {"header": "menu", "items": [{"id": 27}, {"id": 0, "label": "Label 0"}, null, {"id": 93}, {"id": 85}, {"id": 54}, null, {"id": 46, "label": "Label 46"}]}}

{"menu": {"header": "menu", "items": [{"id": 81}]}}

{"menu": {"header": "menu", "items": [{"id": 70, "label": "Label 70"}, {"id": 85, "label": "Label 85"}, {"id": 93, "label": "Label 93"}, {"id": 2}]}}   
```
All IDs are integers between 0 and 100. It can be 10 items maximum for a menu.

Output sample
--------------
Print results in the following way.
```
46
0
248
```
*/

import scala.io.Source
import scala.util.parsing.json.JSON

object Main extends App {
  val contents = Source.fromFile(args(0)).getLines.toList
  val inputs = contents filter (!_.isEmpty)
  val outputs = inputs map sumIDsWithLabel
  outputs.foreach(println)

  def sumIDsWithLabel(s: String) : Int = {
    val jsonval = JSON.parseFull(s)
    val x = jsonval.get.asInstanceOf[Map[String, Map[String, Any]]]
    val lis = x.get("menu").get.get("items").get.asInstanceOf[List[Map[String, Any]]]
    val items = (lis filter (_ != null) filter (_.contains("label")) map (_.get("id").get)).asInstanceOf[List[Double]]
    items.sum.toInt
  }
}
