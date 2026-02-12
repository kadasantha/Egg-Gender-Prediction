# Egg Gender Prediction Model - CORRECTED VERSION
# Based on Lecturer's Feedback: ARF Shafana Madam

# ==============================================================================
# CHANGES MADE:
# 1. Random Forest max_depth: 10 → 3
# 2. Decision Tree max_depth: 10 → 3  
# 3. Gradient Boosting max_depth: 10 → 3
# ==============================================================================

# SECTION 1: Install and Import Dependencies
print("Installing required packages...")
# %pip install pandas numpy scikit-learn matplotlib seaborn openpyxl

# Import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
import joblib
import warnings
warnings.filterwarnings('ignore')

print('All libraries imported successfully!')

# SECTION 2: Mount Google Drive
from google.colab import drive
drive.mount('/content/drive')

# SECTION 3: Configuration
DATASET_PATH = '/content/drive/MyDrive/Egg Gender Prediction Model/Dataset/Egg_Dataset_Extended.xlsx'
MODEL_SAVE_PATH = '/content/drive/MyDrive/Egg Gender Prediction Model/'
RANDOM_STATE = 42
TEST_SIZE = 0.2

print('Configuration complete!')
print(f'Dataset path: {DATASET_PATH}')
print(f'Model will be saved to: {MODEL_SAVE_PATH}')

# SECTION 4: Load Dataset
print('Loading dataset from Google Drive...')
df = pd.read_excel(DATASET_PATH)

print('Dataset loaded successfully!')
print(f'\nDataset shape: {df.shape[0]} rows x {df.shape[1]} columns')
print('\nFirst 5 rows:')
print(df.head())

print('\nColumn names:')
print(df.columns.tolist())

print('\nData types:')
print(df.dtypes)

print('\nMissing values:')
print(df.isnull().sum())

print('\nGender distribution:')
print(df['Gender'].value_counts())

# SECTION 5: Data Visualization
plt.figure(figsize=(15, 5))

# Width distribution
plt.subplot(1, 3, 1)
for gender in df['Gender'].unique():
    data = df[df['Gender'] == gender]['Width']
    plt.hist(data, alpha=0.6, label=gender, bins=20, edgecolor='black')
plt.xlabel('Width (mm)')
plt.ylabel('Frequency')
plt.title('Width Distribution by Gender')
plt.legend()
plt.grid(alpha=0.3)

# Height distribution
plt.subplot(1, 3, 2)
for gender in df['Gender'].unique():
    data = df[df['Gender'] == gender]['Heigth']
    plt.hist(data, alpha=0.6, label=gender, bins=20, edgecolor='black')
plt.xlabel('Height (mm)')
plt.ylabel('Frequency')
plt.title('Height Distribution by Gender')
plt.legend()
plt.grid(alpha=0.3)

# ESI distribution
plt.subplot(1, 3, 3)
for gender in df['Gender'].unique():
    data = df[df['Gender'] == gender]['Shape Index(%)']
    plt.hist(data, alpha=0.6, label=gender, bins=20, edgecolor='black')
plt.xlabel('Shape Index (%)')
plt.ylabel('Frequency')
plt.title('ESI Distribution by Gender')
plt.legend()
plt.grid(alpha=0.3)

plt.tight_layout()
plt.show()

# SECTION 6: Feature Engineering
X = df[['Width', 'Heigth', 'Shape Index(%)']].copy()

# Create additional features
X['Width_Squared'] = X['Width'] ** 2
X['Height_Squared'] = X['Heigth'] ** 2
X['ESI_Squared'] = X['Shape Index(%)'] ** 2
X['Width_Height_Interaction'] = X['Width'] * X['Heigth']

y = df['Gender']

print('Features created:')
print(X.columns.tolist())
print(f'\nFeature matrix shape: {X.shape}')

feature_columns = X.columns.tolist()

# SECTION 7: Prepare Data
label_encoder = LabelEncoder()
y_encoded = label_encoder.fit_transform(y)

print('\nLabel Encoding:')
for i, label in enumerate(label_encoder.classes_):
    print(f'  {label}: {i}')

X_train, X_test, y_train, y_test = train_test_split(
    X, y_encoded, 
    test_size=TEST_SIZE, 
    random_state=RANDOM_STATE, 
    stratify=y_encoded
)

scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

print(f'\nTraining set: {X_train.shape[0]} samples')
print(f'Testing set: {X_test.shape[0]} samples')

# SECTION 8: Train Multiple Models - ✅ CORRECTED VERSION
print('\n' + '='*60)
print('TRAINING MODELS WITH CORRECTED PARAMETERS')
print('='*60)
print('\nTraining models...\n')

# ✅ CORRECTED: max_depth changed from 10 to 3
models = {
    'Random Forest': RandomForestClassifier(
        n_estimators=100, 
        random_state=RANDOM_STATE, 
        max_depth=3  # ✅ CHANGED FROM 10 TO 3
    ),
    'Gradient Boosting': GradientBoostingClassifier(
        n_estimators=100, 
        random_state=RANDOM_STATE,
        max_depth=3  # ✅ CHANGED FROM 10 TO 3
    ),
    'Decision Tree': DecisionTreeClassifier(
        random_state=RANDOM_STATE, 
        max_depth=3  # ✅ CHANGED FROM 10 TO 3
    ),
    'SVM': SVC(
        kernel='rbf', 
        random_state=RANDOM_STATE, 
        probability=True
    ),
    'KNN': KNeighborsClassifier(
        n_neighbors=5
    ),
    'Logistic Regression': LogisticRegression(
        random_state=RANDOM_STATE, 
        max_iter=1000
    )
}

results = {}

for name, model in models.items():
    print(f'Training {name}...', end=' ')
    model.fit(X_train_scaled, y_train)
    y_pred = model.predict(X_test_scaled)
    accuracy = accuracy_score(y_test, y_pred)
    results[name] = accuracy
    print(f'Accuracy: {accuracy*100:.2f}%')

# Select best model
best_model_name = max(results, key=results.get)
best_model = models[best_model_name]
best_accuracy = results[best_model_name]

print(f'\n✅ Best Model: {best_model_name}')
print(f'✅ Accuracy: {best_accuracy*100:.2f}%')
print('='*60)

# SECTION 9: Model Evaluation
y_pred_best = best_model.predict(X_test_scaled)

print('\nClassification Report:')
print(classification_report(y_test, y_pred_best, target_names=label_encoder.classes_))

# Confusion Matrix
cm = confusion_matrix(y_test, y_pred_best)
plt.figure(figsize=(10, 8))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues',
            xticklabels=label_encoder.classes_,
            yticklabels=label_encoder.classes_,
            linewidths=2, linecolor='black')
plt.title(f'Confusion Matrix - {best_model_name}', fontsize=16, fontweight='bold')
plt.ylabel('Actual Gender', fontsize=12)
plt.xlabel('Predicted Gender', fontsize=12)
plt.tight_layout()
plt.show()

# SECTION 10: Feature Importance
if hasattr(best_model, 'feature_importances_'):
    feature_importance = pd.DataFrame({
        'Feature': feature_columns,
        'Importance': best_model.feature_importances_
    }).sort_values('Importance', ascending=False)

    print('\nFeature Importance:')
    print(feature_importance)

    plt.figure(figsize=(10, 6))
    plt.barh(feature_importance['Feature'], feature_importance['Importance'], 
             color='skyblue', edgecolor='black')
    plt.xlabel('Importance')
    plt.title(f'Feature Importance - {best_model_name}', fontsize=14, fontweight='bold')
    plt.gca().invert_yaxis()
    plt.grid(axis='x', alpha=0.3)
    plt.tight_layout()
    plt.show()

# SECTION 11: Save Model
joblib.dump(best_model, MODEL_SAVE_PATH + 'egg_gender_model.pkl')
joblib.dump(scaler, MODEL_SAVE_PATH + 'scaler.pkl')
joblib.dump(label_encoder, MODEL_SAVE_PATH + 'label_encoder.pkl')

print('\n✅ Model saved successfully!')
print(f'Saved to: {MODEL_SAVE_PATH}')
print('\nFiles created:')
print('  1. egg_gender_model.pkl')
print('  2. scaler.pkl')
print('  3. label_encoder.pkl')

# SECTION 12: Test Predictions
sample_size = 10
sample_indices = np.random.choice(X_test.index, sample_size, replace=False)

print('\nSample Predictions:\n')
correct = 0

for i, idx in enumerate(sample_indices, 1):
    sample_data = X.loc[[idx]]
    sample_scaled = scaler.transform(sample_data)
    prediction = best_model.predict(sample_scaled)
    pred_label = label_encoder.inverse_transform(prediction)[0]
    actual_label = y.loc[idx]

    is_correct = actual_label == pred_label
    if is_correct:
        correct += 1

    print(f'Sample {i}:')
    print(f'  Width: {sample_data["Width"].values[0]:.2f} mm')
    print(f'  Height: {sample_data["Heigth"].values[0]:.2f} mm')
    print(f'  ESI: {sample_data["Shape Index(%)"].values[0]:.2f}%')
    print(f'  Actual: {actual_label} | Predicted: {pred_label}')
    print(f'  {"✅ CORRECT" if is_correct else "❌ WRONG"}\n')

print(f'Sample Accuracy: {correct}/{sample_size} ({correct/sample_size*100:.1f}%)')

# SECTION 13: Summary Report
print('\n' + '='*60)
print('TRAINING SUMMARY REPORT - CORRECTED VERSION')
print('='*60)

print(f'\nDataset Statistics:')
print(f'  Total samples: {len(df)}')
print(f'  Training samples: {len(X_train)}')
print(f'  Testing samples: {len(X_test)}')
print(f'  Features used: {len(feature_columns)}')

print(f'\n✅ Best Model: {best_model_name}')
print(f'✅ Training Accuracy: {best_model.score(X_train_scaled, y_train)*100:.2f}%')
print(f'✅ Testing Accuracy: {best_accuracy*100:.2f}%')

print(f'\nModel Parameters (CORRECTED):')
if best_model_name in ['Random Forest', 'Decision Tree', 'Gradient Boosting']:
    print(f'  ✅ max_depth: 3 (changed from 10)')

print(f'\nSaved Files:')
print(f'  1. egg_gender_model.pkl')
print(f'  2. scaler.pkl')
print(f'  3. label_encoder.pkl')

print(f'\n✅ Training Complete!')
print(f'Your model is ready for egg gender prediction!')
print('='*60)

print('\n📝 NOTE: This version addresses lecturer feedback:')
print('   - max_depth reduced from 10 to 3')
print('   - This should prevent overfitting')
print('   - Expected accuracy: ~99% (not 100%)')
