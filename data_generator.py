import os 
import random
import datetime

NCASES = 1000
TARGET_DIR = './'

def gen_one_case(in_i_fd = None, output_fd = None):

    if in_i_fd == None or output_fd == None:
        print("input file is null")
        exit(2)
    
    time = random.getrandbits(31)
    # print(time)
    dt = datetime.datetime.utcfromtimestamp(time)
    # print(dt)
    # print(dt.weekday(), dt.hour, dt.minute, dt.second)
    in_i_fd.write('{}\n'.format(time))
    year = [int(x) for x in str(dt.year)]
    if dt.month >= 10:
        month = [int(x) for x in str(dt.month)]
    else:
        month = ['0']
        month.append(str(dt.month))

    # day = [int(x) for x in str(dt.day)]
    if dt.day >= 10:
        day = [int(x) for x in str(dt.day)]
    else:
        day = ['0']
        day.append(str(dt.day))

    # hour = [int(x) for x in str(dt.hour)]
    if dt.hour >= 10:
        hour = [int(x) for x in str(dt.hour)]
    else:
        hour = ['0']
        hour.append(str(dt.hour))

    # minute = [int(x) for x in str(dt.minute)]
    if dt.minute >= 10:
        minute = [int(x) for x in str(dt.minute)]
    else:
        minute = ['0']
        minute.append(str(dt.minute))

    # sec = [int(x) for x in str(dt.second)]
    if dt.second >= 10:
        sec = [int(x) for x in str(dt.second)]
    else:
        sec = ['0']
        sec.append(str(dt.second))

    if dt.weekday()+1 == 7:
        weekday = 0
    else:
        weekday = dt.weekday()+1
    output_fd.write('{} {} {} {} {} {} {} {} {} {} {} {} {} {}\n'.format(year[0], year[1], year[2], year[3], month[0], month[1], day[0], day[1], hour[0], hour[1], minute[0], minute[1], sec[0], sec[1]))
    output_fd.write('{}\n'.format(weekday))


def main():

    ncases = NCASES
    target_dir = TARGET_DIR
    input_i_file = os.path.join(target_dir, "input.txt")
    output_file = os.path.join(target_dir, "ans.txt")

    in_i_fd = open(input_i_file, "w")
    output_fd = open(output_file, "w")

    in_i_fd.write('{}\n'.format(ncases))
    for n in range(ncases):
        gen_one_case(in_i_fd, output_fd)

    in_i_fd.close()
    output_fd.close()

if __name__ == "__main__":
    main()
