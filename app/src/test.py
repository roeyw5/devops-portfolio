import unittest

class TestPass(unittest.TestCase):
  def test_always_pass(self):
    self.assertTrue(True)

if __name__ == '__main__':
  unittest.main()
