from app.controller.default import Status

def test_is_checking_if_available():
    assert Status.in_stock.is_available()
    assert Status.backorder.is_available()
