#include <cstdio>
#include "cpu.h"

#include "common.h"

namespace StreamCompaction {
    namespace CPU {
        using StreamCompaction::Common::PerformanceTimer;
        PerformanceTimer& timer()
        {
            static PerformanceTimer timer;
            return timer;
        }

        /**
         * CPU scan (prefix sum).
         * For performance analysis, this is supposed to be a simple for loop.
         * (Optional) For better understanding before starting moving to GPU, you can simulate your GPU scan in this function first.
         */
        void scan(int n, int *odata, const int *idata) {
            timer().startCpuTimer();
            // TODO
            odata[0] = 0;
            for (int i = 1; i < n; ++i)
            {
                odata[i] = idata[i - 1] + odata[i - 1];
            }
            timer().endCpuTimer();
        }

        /**
         * CPU stream compaction without using the scan function.
         *
         * @returns the number of elements remaining after compaction.
         */
        int compactWithoutScan(int n, int *odata, const int *idata) {
            timer().startCpuTimer();
            // TODO
            int count = 0;
            for (int i = 0; i < n; ++i)
            {
                if (idata[i])
                {
                    odata[count] = idata[i];
                    ++count;
                }
            }

            timer().endCpuTimer();
            return count;
        }

        /**
         * CPU stream compaction using scan and scatter, like the parallel version.
         *
         * @returns the number of elements remaining after compaction.
         */
        int compactWithScan(int n, int *odata, const int *idata) {
            timer().startCpuTimer();
            // TODO
            int* scan_arr = new int[n];
            odata[0] = idata[0] ? 1 : 0;
            scan_arr[0] = 0;
            for (int i = 1; i < n; ++i)
            {
                odata[i] = idata[i] ? 1 : 0;
                scan_arr[i] = odata[i - 1] + scan_arr[i - 1];
            }

            int count = 0;
            for (int i = 0; i < n; ++i)
            {
                if (odata[i])
                {
                    odata[scan_arr[i]] = idata[i];
                    ++count;
                }
            }

            timer().endCpuTimer();
            return count;
        }

        void sort(int n, int* odata, const int* idata)
        {
            memcpy(odata, idata, n * sizeof(int));
            timer().startCpuTimer();
            std::sort(odata, odata + n);
            timer().endCpuTimer();
        }
    }
}
