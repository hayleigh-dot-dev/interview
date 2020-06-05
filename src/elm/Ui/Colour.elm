module Ui.Colour exposing
  ( Colour -- Type constructors are *not* exposed for this type.
  , black, white, grey, red, orange, yellow, green, teal, blue, indigo, purple, pink
  , darken, darkenBy, lighten, lightenBy
  , toString
  , toText, toBackground, toBorder
  )

-- Imports ---------------------------------------------------------------------
import Html exposing (Attribute)
import Html.Attributes

-- Types -----------------------------------------------------------------------
-- The colour type represents the palette of colours provided by default in
-- tailwindcss. The `Int` is necessary to indicate a shade from 100 to 900. To
-- avoid incorrect shades such as `666` from being used, a colour cannot be
-- created directly.
type Colour
  = Black
  | White
  | Grey Int
  | Red Int
  | Orange Int
  | Yellow Int
  | Green Int
  | Teal Int
  | Blue Int
  | Indigo Int
  | Purple Int
  | Pink Int

-- Functions -------------------------------------------------------------------
-- These functions create colours with a default shade of 500 (for non black or
-- white colours). These can then be manipulated with `darken` and `lighten`
-- below.
black : Colour
black = Black
white : Colour
white = White
grey : Colour
grey = Grey 500
red : Colour
red = Red 500
orange : Colour
orange = Orange 500
yellow : Colour
yellow = Yellow 500
green : Colour
green = Green 500
teal : Colour
teal = Teal 500
blue : Colour
blue = Blue 500
indigo : Colour
indigo = Indigo 500
purple : Colour
purple = Purple 500
pink : Colour
pink = Pink 500

-- Increases the shade of a colour by 100. Ensures shades cannot go above 900
-- and does not effect Black or White.
darken : Colour -> Colour
darken c =
 case c of
    Black ->
      Black

    White ->
      Black

    Grey shade ->
      if shade < 900 then Grey (shade + 100) else Grey shade

    Red shade ->
      if shade < 900 then Red (shade + 100) else Red shade

    Orange shade ->
      if shade < 900 then Orange (shade + 100) else Orange shade

    Yellow shade ->
      if shade < 900 then Yellow (shade + 100) else Yellow shade

    Green shade ->
      if shade < 900 then Green (shade + 100) else Green shade

    Teal shade ->
      if shade < 900 then Teal (shade + 100) else Teal shade

    Blue shade ->
      if shade < 900 then Blue (shade + 100) else Blue shade

    Indigo shade ->
      if shade < 900 then Indigo (shade + 100) else Indigo shade

    Purple shade ->
      if shade < 900 then Purple (shade + 100) else Purple shade

    Pink shade ->
      if shade < 900 then Pink (shade + 100) else Pink shade

-- Convinient way to darken something `n` number of times without manually
-- chaining together multiple calls to `darken`.
darkenBy : Int -> Colour -> Colour
darkenBy n colour =
  List.repeat n darken
    |> List.foldl (<|) colour

-- Decreases the shade of a colour by 100. Ensures shades cannot go below 100
-- and does not effect Black or White.
lighten : Colour -> Colour
lighten c =
 case c of
    Black ->
      Black

    White ->
      Black

    Grey shade ->
      if shade > 100 then Grey (shade - 100) else Grey shade

    Red shade ->
      if shade > 100 then Red (shade - 100) else Red shade

    Orange shade ->
      if shade > 100 then Orange (shade - 100) else Orange shade

    Yellow shade ->
      if shade > 100 then Yellow (shade - 100) else Yellow shade

    Green shade ->
      if shade > 100 then Green (shade - 100) else Green shade

    Teal shade ->
      if shade > 100 then Teal (shade - 100) else Teal shade

    Blue shade ->
      if shade > 100 then Blue (shade - 100) else Blue shade

    Indigo shade ->
      if shade > 100 then Indigo (shade - 100) else Indigo shade

    Purple shade ->
      if shade > 100 then Purple (shade - 100) else Purple shade

    Pink shade ->
      if shade > 100 then Pink (shade - 100) else Pink shade

-- Convinient way to lighten something `n` number of times without manually
-- chaining together multiple calls to `lighten`.
lightenBy : Int -> Colour -> Colour
lightenBy n colour =
  List.repeat n lighten
    |> List.foldl (<|) colour

-- Concerts a colour to a tailwindcss-compatible string. The colour `Blue 500`,
-- for example, will convert to "blue-500". This is used by `toText` and
-- `toBackground` below to create tailwindcss-compatible class attributes.
toString : Colour -> String
toString c =
  case c of
    Black ->
      "black"
    
    White ->
      "white"
    
    Grey shade ->
      "gray-" ++ String.fromInt shade 
    
    Red shade ->
      "red-" ++ String.fromInt shade 
    
    Orange shade ->
      "orange-" ++ String.fromInt shade 
    
    Yellow shade ->
      "yellow-" ++ String.fromInt shade 
    
    Green shade ->
      "green-" ++ String.fromInt shade 
    
    Teal shade ->
      "teal-" ++ String.fromInt shade 
    
    Blue shade ->
      "blue-" ++ String.fromInt shade 
    
    Indigo shade ->
      "indigo-" ++ String.fromInt shade 
    
    Purple shade ->
      "purple-" ++ String.fromInt shade 
    
    Pink shade ->
      "pink=" ++ String.fromInt shade 
    

--
toText : Colour -> Attribute msg
toText c =
  Html.Attributes.class <| "text-" ++ toString c

--
toBackground : Colour -> Attribute msg
toBackground c =
  Html.Attributes.class <| "bg-" ++ toString c

--
toBorder : Colour -> Attribute msg
toBorder c =
  Html.Attributes.class <| "border-" ++ toString c