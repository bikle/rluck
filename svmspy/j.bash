
./5min_data.bash  HAL
./5min_data.bash  HD
./5min_data.bash  HES
./5min_data.bash  HL
./5min_data.bash  HOC
./5min_data.bash  HON
./5min_data.bash  HPQ
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash HAL
./svmtkr.bash HD
./svmtkr.bash HES
./svmtkr.bash HL
./svmtkr.bash HOC
./svmtkr.bash HON
./svmtkr.bash HPQ
