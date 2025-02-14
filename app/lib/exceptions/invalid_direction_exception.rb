##
# Exception to be thrown when a PLACE command comes with direction other
# than NORTH, WEST, SOUTH, EAST
#
class InvalidDirectionException < Exception
end