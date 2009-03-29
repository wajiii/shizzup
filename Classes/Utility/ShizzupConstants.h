/*
 *  ShizzupConstants.h
 *  Shizzup
 *
 *  Created by Bill Jackson <wajiii@gmail.com> on 2009/02/04.
 *  Copyright 2009 waj3. All rights reserved.
 *
 */

//#include <Carbon/Carbon.h>

#define SHIZZOW_API_URL_PREFIX  @"https://v0.api.shizzow.com:443"
#define SHIZZOW_API_PATH_PLACES @"/places"
#define SHIZZOW_API_PATH_SHOUTS @"/shouts"
#define SHIZZOW_API_PLACES_RADIUS_DEFAULT 0.25
#define SHIZZOW_API_PLACES_RADIUSUNIT_DEFAULT @"km"
#define SHIZZOW_API_PLACES_LIMIT_DEFAULT 100
#define SHIZZOW_API_SHOUTS_LIMIT_DEFAULT 50
#define SHIZZOW_API_SHOUTS_RADIUS_DEFAULT 5.0
#define SHIZZOW_API_SHOUTS_RADIUSUNIT_DEFAULT @"mi"

#define ICON_WIDTH 48.0
#define ICON_HEIGHT 48.0
#define ICON_CORNER_WIDTH 8.0
#define ICON_CORNER_HEIGHT 8.0
#define SHOUTCELL_MARGIN_HORIZONTAL 8.0
#define SHOUTCELL_MARGIN_VERTICAL 4.0
#define LABEL_FONT_SIZE 14.0
#define AGE_FONT_SIZE 12.0
#define CELL_HEIGHT_MIN (ICON_HEIGHT + (SHOUTCELL_MARGIN_VERTICAL * 2))

#define MAP_SCALE_INITIAL    50.0
// Green Dragon
//#define MAP_LAT_INITIAL     45.515963
//#define MAP_LON_INITIAL   -122.656525
// Oracle
//#define MAP_LAT_INITIAL     45.51538300000000
//#define MAP_LON_INITIAL   -122.67957600000000
// Pioneer Courthouse Square
#define MAP_LAT_INITIAL     45.51901900000000
#define MAP_LON_INITIAL   -122.67874100000000
