from enum import Enum

class Status(Enum):
    in_stock = 0
    backorder = 1
    sold = 2
    reserved = 3

    def is_available(self):
        return self.value != self.sold or self.value != self.reserved
