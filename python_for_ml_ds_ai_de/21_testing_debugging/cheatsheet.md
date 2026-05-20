# Module 21: Testing & Debugging — Cheatsheet

## pytest Quick Reference

```python
# Basic test
def test_add():
    assert add(2, 3) == 5

# Parametrized test
@pytest.mark.parametrize("a,b,expected", [
    (2, 3, 5), (0, 0, 0), (-1, 1, 0)
])
def test_add_params(a, b, expected):
    assert add(a, b) == expected

# Fixture
@pytest.fixture
def sample_data():
    return pd.DataFrame({"x": [1, 2, 3]})

def test_shape(sample_data):
    assert sample_data.shape == (3, 1)

# Fixture scoping
@pytest.fixture(scope="session")  # module, class, function
def trained_model():
    model = train_model()
    return model

# conftest.py — shared fixtures
# Place in test directory, available to all tests automatically

# Markers
@pytest.mark.slow
def test_training_loop(): ...

# Run: pytest -m slow

# Temporary directories
def test_output(tmpdir):
    path = tmpdir / "output.csv"
    save_data(path)
    assert path.exists()
```

## Assert Patterns

```python
assert result == expected
assert result is None
assert "error" in str(context.exception)
assert pytest.approx(0.333, rel=1e-3)  # float comparison
assert_frame_equal(df1, df2)           # pandas testing
```

## unittest Module

```python
import unittest
from unittest.mock import MagicMock, patch

class TestModel(unittest.TestCase):
    def setUp(self):
        self.model = Model()

    def tearDown(self):
        # cleanup
        pass

    def test_predict(self):
        result = self.model.predict([[1, 2]])
        self.assertEqual(result.shape, (1,))

if __name__ == "__main__":
    unittest.main()
```

## Mocking

```python
from unittest.mock import Mock, MagicMock, patch, PropertyMock

# Basic mock
mock_model = Mock()
mock_model.predict.return_value = np.array([0.8])
mock_model.predict.assert_called_once()

# Patch decorator
@patch("module.Model.predict")
def test_prediction(mock_predict):
    mock_predict.return_value = np.array([0.5])
    result = run_inference()
    assert result == 0.5

# Patch context manager
with patch("module.train_model") as mock_train:
    mock_train.return_value = mock_model
    result = pipeline.run()

# Property mock
with patch("module.Model.version", new_callable=PropertyMock) as mock_ver:
    mock_ver.return_value = "v2"
    assert get_version() == "v2"

# monkeypatch (pytest)
def test_config(monkeypatch):
    monkeypatch.setenv("MODEL_PATH", "/tmp/model.pkl")
    monkeypatch.setattr("module.SLOW_FLAG", False)
```

## Debugging with pdb

```python
# Set breakpoint (Python 3.7+)
breakpoint()  # or import pdb; pdb.set_trace()

# ipdb (richer experience)
import ipdb; ipdb.set_trace()

# Post-mortem
try:
    run_pipeline()
except Exception:
    import pdb; pdb.post_mortem()

# Common pdb commands
# n (next), s (step into), c (continue), q (quit)
# p var (print variable), pp var (pretty print)
# l (list source), ll (list full source)
# b 42 (break at line 42), b func_name
# !expr (execute Python expression)
# h (help)

# Conditional breakpoint
breakpoint() if loss > 100 else None
```

## Logging for Debugging

```python
import logging

logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    filename="debug.log",
)
logger = logging.getLogger(__name__)

# Usage
logger.debug(f"Epoch {epoch}, loss={loss:.4f}")
logger.info("Training started")
logger.warning("Learning rate decay triggered")
logger.error(f"NaN detected in gradients at step {step}")

# Log to both file and console
handler = logging.StreamHandler()
handler.setLevel(logging.DEBUG)
logger.addHandler(handler)
```

## Test Coverage

```bash
# Install
pip install pytest-cov

# Run with coverage
pytest --cov=src/
pytest --cov=src/ --cov-report=html
pytest --cov=src/ --cov-report=term-missing

# Configuration in pyproject.toml
# [tool.coverage.run]
# source = ["src"]
# [tool.coverage.report]
# fail_under = 80
```

## GitHub Actions CI

```yaml
# .github/workflows/tests.yml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: "3.10"
      - run: pip install -r requirements.txt
      - run: pip install pytest pytest-cov
      - run: pytest --cov=src/ --cov-fail-under=80
```

## TDD Workflow

```
1. RED: Write a failing test
2. GREEN: Write minimal code to pass
3. REFACTOR: Improve code while tests pass
```

## ML-Specific Testing Patterns

```python
# Test data transformation
def test_scale_features():
    scaler = StandardScaler()
    data = np.array([[1.0], [2.0], [3.0]])
    scaled = scaler.fit_transform(data)
    assert pytest.approx(scaled.mean(), abs=1e-10) == 0.0
    assert pytest.approx(scaled.std(), abs=1e-10) == 1.0

# Test model output shape
def test_model_output_shape():
    model = RandomForestClassifier()
    X = np.random.rand(10, 5)
    y = np.random.randint(0, 2, 10)
    model.fit(X, y)
    preds = model.predict(X)
    assert preds.shape == (10,)

# Mock training to avoid slow tests
@patch("src.model.train_model")
def test_pipeline(mock_train):
    mock_model = Mock()
    mock_model.predict.return_value = np.array([0, 1, 0])
    mock_train.return_value = mock_model
    results = run_pipeline()
    assert len(results) == 3

# Test deterministic behavior with seed
def test_reproducible_split():
    X1, _, y1, _ = train_test_split(X, y, random_state=42)
    X2, _, y2, _ = train_test_split(X, y, random_state=42)
    assert np.array_equal(X1, X2)
```

## Useful pytest Flags

```bash
pytest -v              # verbose
pytest -k "test_train" # run tests matching expression
pytest -x              # stop on first failure
pytest --pdb           # enter pdb on failure
pytest -s              # show print statements
pytest --tb=long       # long traceback format
pytest --lf            # run last failed first
pytest --ff            # run failed first, then rest
```
